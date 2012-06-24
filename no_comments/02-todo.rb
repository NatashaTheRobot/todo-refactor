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
      results = []
      @tasks.each do |task|
        if task.complete?
          results << task
        end        
      end

      results.sort_by { |task| task.completed_at }
    end

    # Return an array of incomplete tasks ordered by creation date
    def incomplete_tasks
      results = []
      @tasks.each do |task|
        if task.incomplete?
          results << task
        end
      end

      results.sort_by { |task| task.created_at }
    end
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
