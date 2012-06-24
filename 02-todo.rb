# Author: Jesse Farmer <jesse@devbootcamp.com>
# Date:   June 23, 2012

# We're going to "Demeterize" this code
# See http://en.wikipedia.org/wiki/Law_of_Demeter
#
# The Law of Demeter is a software design guideline which says, roughly,
# that a method M in an object O may only do the following:
#
# * Invoke methods on O
# * Invoke methods on the parameters of M
# * Any object created or instantiated within M
# * O's component objects (e.g., instance variables)
# * Global variables accessible in M
#
# Why?  This promotes loose coupling
# http://en.wikipedia.org/wiki/Loose_coupling
#
# Two parts of a system -- call them A and B  -- are "loosely coupled" if
# A doesn't have to know anything about B's internal state or implementation
# to get its job done (and vice versa).
#
# Instead, A and B should have standard interfaces through which they communicate
#
# Imagine we had a bunch of Animal objects (dogs, ducks, cats, etc.)
# Each object had a "speak" method.  Dogs bark, cats meow, ducks quack, etc.
#
# The Law of Demeter says if we're given an animal object we should write something like this:
#
# def make_animal_speak(animal)
#   animal.speak!
# end
#
# rather than
# 
# def make_animal_speak(animal)
#   animal.voice_box.make_sound!
# end
#
# We're now assuming things about the internal state of the animal.
# For example, when crickets make their sound, do they have a voice box?
# 
# We don't actually care if the animal has a voice box.  We only
# care if it understands what "speak!" means.  If it doesn't it will
# complain (i.e., raise an exception).

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
        # Demeterize!
        # 
        # We know too much about the internal state of a Task
        # here.  Every kind of task needs to have a completed_at
        # field, and it must be nil if a task is complete.
        # 
        # if !task.completed_at.nil?
        #  results << task
        # end
        
        # Instead, the Law of Demeter says we should do this:
        if task.complete?
          results << task
        end
        
        # Now we're not assuming anything about a Task, and
        # it's up to a Task object to decide what "complete?"
        # means.
        #
        # You can think of it this way.  We want to ask,
        # "Task, are you complete?" rather than
        # "Task, is your completed_at timestamp not nil?"
      end

      results.sort_by { |task| task.completed_at }
    end

    # Return an array of incomplete tasks ordered by creation date
    def incomplete_tasks
      results = []
      @tasks.each do |task|
        # Demeterize this, too.
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
