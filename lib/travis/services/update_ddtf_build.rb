require 'active_support/core_ext/hash/except'
require 'travis/support/instrumentation'
require 'travis/services/base'

module Travis
  module Services
    class UpdateDdtfBuild < Base
      extend Travis::Instrumentation

      register :update_ddtf_build

      EVENT = [:abort]

      def run
        # build.send(:instance_variable_set, :@readonly, false)
        build.cancel!
      end

      instrument :run

      def build
        @build || run_service(:find_build, data)
      end

      def data
        @data ||= begin
                    data = {}
                    data = params[:data].symbolize_keys if params && params[:data]
                    data
                  end
      end

      def event
        @event ||= EVENT.detect { |event| event == params[:event].try(:to_sym) } || raise_unknown_event
      end

      def raise_unknown_event
        raise ArgumentError, "Unknown event: #{params[:event]}"
      end

      class Instrument < Notification::Instrument
        def run_completed
          publish(
            msg: "event: #{target.event} for <build id=#{target.data[:id]}>",
            build_id: target.data[:id],
            event: target.event
          )
        end
      end

      Instrument.attach_to(self)
    end
  end
end

