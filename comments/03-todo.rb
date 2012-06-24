# Author: Jesse Farmer <jesse@devbootcamp.com>
# Date:   June 23, 2012

# Now, we take a step back and ask ourselves
# "What operations do we want to perform on a list, really?"
#
# We have two "meaty" methods right now: 
# List#complete_tasks and List#incomplete_tasks
#
# If you move one level of abstraction up, these two methods are doing the same thing
# Namely, returning some kind of sublist of the todo list
#
# We can re-phrase these methods as:
# * Give me all tasks such that the task is complete
# * Give me all tasks such that the task is incomplete
#
# Eventually, we'll want to do more things, like:
# * Give me all tasks such that the task is tagged with X
# * Give me all tasks such that the task is tagged with all tags X, Y, Z
# * Give me all tasks such that the task is tagged with any of the tags X, Y, and Z
# * Give me all tasks such that the task has priority X
# * Give me all tasks such that the task has priority greater than X
#
# You can also imagine asking for things like
# * Give me all tasks such that the task is due today
# * Give me all tasks such that the task is due within the next week
# * Give me all tasks such that the task was completed yesterday
# etc.
#
# The part after "Give me all tasks such that..." is called a predicate.
# http://en.wikipedia.org/wiki/Predicate_(mathematical_logic)
#
# A predicate is a function which returns true or false for a given input
# e.g., "X is even" is a predicate.
#
# This scenario is incredibly common, as you can imagine, and arrays
# in Ruby have a method called "select" which takes a predicate as its
# input in the form of a block.
#
# Examples:
# Give me all the numbers from 1 to 10 such that the number is even
# (1..10).select { |num| num.even? }  # => [2,4,6,8,10]
#
# Give me all the numbers from 1 to 10 such that the number is odd
# (1..10).select { |num| num.odd? }   # => [1,3,5,7,9]
#
# Give me all the words in this array such that the word is longer than 5 letters
# ['cat', 'hippopotamus', 'whale', 'giraffe'].select { |word| word.length > 5} #=> ['hippopotamus', 'giraffe']
#
# See http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-select

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
      # Give me all the tasks such that the task is complete
      # results = @tasks.select { |task| task.complete? }
      # results.sort_by { |task| task.completed_at }
      #
      # We can combine this into a single line
      
      @tasks.select { |task| task.complete? }.sort_by { |task| task.completed_at }
    end

    # Return an array of incomplete tasks ordered by creation date
    def incomplete_tasks
      # Give me all the tasks such that the task is incomplete
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
