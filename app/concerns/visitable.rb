module Visitable

  module ClassMethods
    def get_top_visited(options = {})
      options.reverse_merge!(filter:0, limit:10)
      filter = options[:filter]
      filter = [filter] unless options[:filter].respond_to?(:flatten) || filter.nil?
      filter.flatten!

      self.where("#{self.table_name}.last_visit_date >= '#{(Time.now - 30.days)}'").
           where("#{self.table_name}.id not in (?)", filter).
           order("#{self.table_name}.recent_visits DESC").
           limit(options[:limit])
    end
  end

  def self.included(base)
    base.has_many :visits, :as => :visitable
    base.extend(ClassMethods)
  end

  def visit(user_id)
    self.visits << Visit.new({:person_id=>user_id})
    self.total_visits ||= 0
    self.total_visits = self.total_visits + 1
    self.last_visit_date = Time.now
    self.recent_visits = calculate_recent_visits
  end

  def visit!(user_id)
    # We don't want to change the update_at time during a visit tracking only during real changes.
    self.class.record_timestamps = false

    self.visit(user_id)
    self.save

    self.class.record_timestamps = true
  end

  def calculate_recent_visits
    self.visits.where("created_at >= '#{(Time.now - 30.days)}'").count
  end

end

