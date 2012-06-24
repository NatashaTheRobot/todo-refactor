# Author: Jesse Farmer <jesse@devbootcamp.com>
# Date:   June 23, 2012

module Todo
  class List
    attr_reader :tasks

    def initialize
      @tasks = []
    end
    
    # Append a task with the given description to the todo list
    def append(description)
      @tasks << Task.new(description)
    end
    alias :add :append
        
    # Prepend a task with the given description to the todo list
    def prepend(description)
      @tasks.unshift Task.new(description)
    end

    # Remove a task with the given task_id to the todo list
    def remove(task_id)
      @tasks.delete_at(task_id - 1)
    end

    # Mark the task with the given task_id as complete
    def complete!(task_id)
      @tasks[task_id - 1].complete!
    end

    # Return an array of complete tasks ordered by completion date
    def complete_tasks
      @tasks.select { |task| task.complete? }.sort_by { |task| task.completed_at }
    end

    # Return an array of incomplete tasks ordered by creation date
    def incomplete_tasks
      @tasks.select { |task| task.incomplete? }.sort_by { |task| task.created_at }
    end
    
    # Eventually, we'll write these methods:
    #
    # Returns an array of all tasks tagged with the given tag
    # def with_tag(tag)
    #   @tasks.select { |task| task.has_tag?(tag) }
    # end
    #
    # Returns an array of all tasks tagged all the given tags, input as an array
    # def with_all_tags(tags)
    #   @tasks.select { |task| task.has_all_tags?(tag) }
    # end
    #
    # Returns an array of all tasks tagged with any of the given tags, input as an array
    # def with_any_tag(tag)
    #   @tasks.select { |task| task.has_any_tag?(tags) }
    # end
  end
  
  class Task
    attr_reader :description, :created_at, :completed_at
    
    def initialize(description)
      @description = description
      
      @created_at   = Time.now
      @completed_at = nil
    end

    # Mark the task as completed
    def complete!
      @completed_at = Time.now
    end

    # Returns true if a task is incomplete
    def incomplete?
      @completed_at.nil?
    end

    # Returns true if a task is complete
    def complete?
      !incomplete?
    end
  end
end
