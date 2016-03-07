require 'travis/services/base'

module Travis
  module Services
    class CancelDdtfBuild < Base
      extend Travis::Instrumentation

      register :cancel_ddtf_build
      attr_reader :id

      def initialize(*)
        super

        @id = params[:id]
        @exchnage_name = params[:user]
        @user = params[:user]
      end

      def run
        publish!
      end
      instrument :run

      def messages
        messages = []
        messages << { :notice => 'The build was successfully cancelled.' }
        messages << { :error  => 'You are not authorized to cancel this build.' } unless authorized?
        messages << { :error  => 'Build not found.' } unless build
        messages
      end

      def publish!
        publisher_params = { name: Travis.config.ddtf.command_node_queue, mandatory: true, immediate: true }
        routing_key = "#{Traivs.config.ddtf.cancel_command_prefix}#{id}"

        publisher = Travis::Amqp::Publisher.new(routing_key, publisher_params)

        publisher.publish({ stopped_by: current_user.login }.to_json)
      end

      def authorized?
        true
      end

      def build
        @build ||= run_service(:find_build, params)
      end

      class Instrument < Notification::Instrument
        def run_completed
          publish(
            :msg => "for <Build id=#{target.id}> (#{target.current_user.login})",
            :result => result
          )
        end
      end
      Instrument.attach_to(self)
    end
  end
end
