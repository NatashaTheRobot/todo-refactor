# Author: Jesse Farmer <jesse@devbootcamp.com>
# Date:   June 23, 2012

# One last abstraction...

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

    # Returns an array of tasks for which the given block returns true
    #
    # If you take a block as an input and want to hand it off to another
    # method which accepts a block as an input, this is how you do it.
    #
    # Because we're typing @tasks.select all over the place, let's just
    # create a method which does that.
    #
    # Now we have a standard interface for creating sublists.
    def sublist(&block)
      # The block is, e.g., { |task| task.complete? }, { |task| task.incomplete? }, etc.
      @tasks.select(&block)
    end

    # Return an array of complete tasks ordered by completion date
    def complete_tasks
      sublist { |task| task.complete? }.sort_by { |task| task.completed_at }
    end

    # Return an array of incomplete tasks ordered by creation date
    def incomplete_tasks
      # Give me all the tasks such that the task is incomplete
      sublist { |task| task.incomplete? }.sort_by { |task| task.created_at }
    end
    
    # Returns an array of all tasks tagged with the given tag
    # def with_tag(tag)
    #   sublist { |task| task.has_tag?(tag) }
    # end
    #
    # Returns an array of all tasks tagged all the given tags, input as an array
    # def with_all_tags(tags)
    #   sublist { |task| task.has_all_tags?(tag) }
    # end
    #
    # Returns an array of all tasks tagged with any of the given tags, input as an array
    # def with_any_tag(tag)
    #   sublist { |task| task.has_any_tag?(tags) }
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
