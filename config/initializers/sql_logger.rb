module SQLLogger
  def self.setup
    @queries = []
    ActiveSupport::Notifications.subscribe("sql.active_record") do |name, started, finished, unique_id, payload|
      unless payload[:name] == "SCHEMA"
        @queries << payload[:sql]
      end
    end
  end

  def self.queries
    @queries
  end

  def self.clear
    @queries = []
  end
end

SQLLogger.setup
