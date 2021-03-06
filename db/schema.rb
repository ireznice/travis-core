# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150325152534) do

  create_table "annotation_providers", :force => true do |t|
    t.string   "name"
    t.string   "api_username"
    t.string   "api_key"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "annotations", :force => true do |t|
    t.integer  "job_id",                 :null => false
    t.string   "url"
    t.text     "description",            :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "annotation_provider_id", :null => false
    t.string   "status"
  end

  create_table "broadcasts", :force => true do |t|
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.string   "kind"
    t.string   "message"
    t.boolean  "expired"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "builds", :force => true do |t|
    t.integer  "repository_id"
    t.string   "number"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "config"
    t.integer  "commit_id"
    t.integer  "request_id"
    t.string   "state"
    t.integer  "duration"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "event_type"
    t.string   "previous_state"
    t.text     "pull_request_title"
    t.integer  "pull_request_number"
    t.string   "branch"
    t.datetime "canceled_at"
    t.string   "cached_matrix_ids",   :limit => nil
    t.datetime "received_at"
  end

  add_index "builds", ["id", "repository_id", "event_type"], :name => "index_builds_on_id_repository_id_and_event_type_desc", :order => {"id"=>:desc}
  add_index "builds", ["repository_id", "event_type", "state", "branch"], :name => "index_builds_on_repository_id_and_event_type_and_state_and_bran"
  add_index "builds", ["repository_id", "event_type"], :name => "index_builds_on_repository_id_and_event_type"
  add_index "builds", ["repository_id", "state"], :name => "index_builds_on_repository_id_and_state"
  add_index "builds", ["request_id"], :name => "index_builds_on_request_id"

  create_table "commits", :force => true do |t|
    t.integer  "repository_id"
    t.string   "commit"
    t.string   "ref"
    t.string   "branch"
    t.text     "message"
    t.string   "compare_url"
    t.datetime "committed_at"
    t.string   "committer_name"
    t.string   "committer_email"
    t.string   "author_name"
    t.string   "author_email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "commits", ["repository_id"], :name => "index_commits_on_repository_id", :unique => true

  create_table "emails", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "emails", ["email"], :name => "index_emails_on_email"
  add_index "emails", ["user_id"], :name => "index_emails_on_user_id"

  create_table "jobs", :force => true do |t|
    t.integer  "repository_id"
    t.integer  "commit_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.string   "queue"
    t.string   "type"
    t.string   "state"
    t.string   "number"
    t.text     "config"
    t.string   "worker"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.text     "tags"
    t.boolean  "allow_failure", :default => false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "result"
    t.datetime "queued_at"
    t.datetime "canceled_at"
    t.datetime "received_at"
  end

  add_index "jobs", ["owner_id", "owner_type", "state"], :name => "index_jobs_on_owner_id_and_owner_type_and_state"
  add_index "jobs", ["repository_id"], :name => "index_jobs_on_repository_id"
  add_index "jobs", ["state", "owner_id", "owner_type"], :name => "index_jobs_on_state_owner_type_owner_id"
  add_index "jobs", ["type", "source_id", "source_type"], :name => "index_jobs_on_type_and_owner_id_and_owner_type"

  create_table "log_parts", :force => true do |t|
    t.integer  "log_id",     :null => false
    t.text     "content"
    t.integer  "number"
    t.boolean  "final"
    t.datetime "created_at"
  end

  add_index "log_parts", ["log_id", "number"], :name => "index_log_parts_on_log_id_and_number"

  create_table "logs", :force => true do |t|
    t.integer  "job_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "aggregated_at"
    t.datetime "archived_at"
    t.datetime "purged_at"
    t.boolean  "archiving"
    t.boolean  "archive_verified"
    t.integer  "removed_by"
    t.datetime "removed_at"
  end

  add_index "logs", ["archive_verified"], :name => "index_logs_on_archive_verified"
  add_index "logs", ["archived_at"], :name => "index_logs_on_archived_at"
  add_index "logs", ["job_id"], :name => "index_logs_on_job_id"

  create_table "memberships", :force => true do |t|
    t.integer "organization_id"
    t.integer "user_id"
  end

  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "login"
    t.integer  "github_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "avatar_url"
    t.string   "location"
    t.string   "email"
    t.string   "company"
    t.string   "homepage"
  end

  add_index "organizations", ["github_id"], :name => "index_organizations_on_github_id", :unique => true

  create_table "permissions", :force => true do |t|
    t.integer "user_id"
    t.integer "repository_id"
    t.boolean "admin",         :default => false
    t.boolean "push",          :default => false
    t.boolean "pull",          :default => false
  end

  add_index "permissions", ["repository_id"], :name => "index_permissions_on_repository_id"
  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

# Could not dump table "repositories" because of following StandardError
#   Unknown type 'json' for column 'settings'

  create_table "requests", :force => true do |t|
    t.integer  "repository_id"
    t.integer  "commit_id"
    t.string   "state"
    t.string   "source"
    t.text     "payload"
    t.string   "token"
    t.text     "config"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "event_type"
    t.string   "comments_url"
    t.string   "base_commit"
    t.string   "head_commit"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "result"
    t.string   "message"
  end

  add_index "requests", ["commit_id"], :name => "index_requests_on_commit_id"
  add_index "requests", ["head_commit"], :name => "index_requests_on_head_commit"
  add_index "requests", ["repository_id"], :name => "index_requests_on_repository_id"

  create_table "ssl_keys", :force => true do |t|
    t.integer  "repository_id"
    t.text     "public_key"
    t.text     "private_key"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "ssl_keys", ["repository_id"], :name => "index_ssl_key_on_repository_id"

  create_table "test_case_results", :force => true do |t|
    t.integer  "position"
    t.integer  "job_id"
    t.integer  "test_case_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "test_case_results", ["job_id"], :name => "index_test_case_results_on_job_id"
  add_index "test_case_results", ["test_case_id"], :name => "index_test_case_results_on_test_case_id"

  create_table "test_cases", :force => true do |t|
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "test_step_data", :force => true do |t|
    t.string   "name",                                   :null => false
    t.text     "message"
    t.boolean  "crashed",             :default => false, :null => false
    t.integer  "test_step_result_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "test_step_data", ["test_step_result_id"], :name => "index_test_step_data_on_test_step_result_id"

  create_table "test_step_results", :force => true do |t|
    t.string   "result",              :null => false
    t.integer  "position"
    t.datetime "started_at"
    t.integer  "duration"
    t.integer  "test_case_result_id"
    t.integer  "test_step_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "test_step_results", ["test_case_result_id"], :name => "index_test_step_results_on_test_case_result_id"
  add_index "test_step_results", ["test_step_id"], :name => "index_test_step_results_on_test_step_id"

  create_table "test_steps", :force => true do |t|
    t.text     "description",  :null => false
    t.integer  "test_case_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "test_steps", ["test_case_id"], :name => "index_test_steps_on_test_case_id"

  create_table "tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "urls", :force => true do |t|
    t.string   "url"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "login"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "is_admin",           :default => false
    t.integer  "github_id"
    t.string   "github_oauth_token"
    t.string   "gravatar_id"
    t.string   "locale"
    t.boolean  "is_syncing"
    t.datetime "synced_at"
    t.text     "github_scopes"
    t.boolean  "education"
  end

  add_index "users", ["github_id"], :name => "index_users_on_github_id", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login"

end
