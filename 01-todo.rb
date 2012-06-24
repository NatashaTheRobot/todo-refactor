# Author: Jesse Farmer <jesse@devbootcamp.com>
# Date:   June 23, 2012


# If we have an app or library that has multiple classes
# it's good practice to put them inside a module.
#
# This keeps those class names out of the global namespace,
# 
# Instead of calling, e.g., List.new we now call Todo::List.new

module Todo
  class List
    # Don't use attr_accessor.  We don't want the outside world messing
    # with out task array directly.  We define the interfaces through
    # which they're allowed to modify it
    attr_reader :tasks

    def initialize
      # Rather than calling this instance variable @list or @todo,
      # it should indicate (without being overly verbose) what
      # sorts of things we expect to go in it
      #
      # In this case, it's an array of Task objects, to we'll
      # call it @tasks

      @tasks = []
    end
    
    def append(description)
      # Some people might wonder whether we should pass in a Task
      # object, or the description for the task object here
      #
      # A good interface might accept both, but if you have to accept
      # only one, it's probably more humane to accept the plain-text
      # description of the tasks rather than relying on whoever is using
      # your library to instantiate a new Task object

      @tasks << Task.new(description)
    end
    
    # alias :new_method :old_method creates a method new_method
    # which is identical to old_method.  This in this case,
    # we're making List#add the same as List#append
    alias :add :append
    
    
    # Prepend a task to the todo list
    #
    # As a rule, you should keep your variable names consistent
    # Don't call the input to this method "task" unless it's actually a task
    #
    # Because a Task object has a description, and expects a description
    # when initialized, we should call it "description" here, too.
    def prepend(description)
      @tasks.unshift Task.new(description)
    end

    # Remove a task with the given task_id from the todo list
    #
    # Again, notice the variable name.  It clearly indicates its
    # purpose.
    #
    # Why these methods don't have bangs (!) is a bit hard to explain.
    # It's mostly linguistic, I think.  add, remove, append, prepend, etc.
    # already have a connotation of being destructive, so the bang
    # is redundant
    def remove(task_id)
      # We pass in a 1-indexed ID because that's more humane
      @tasks.delete_at(task_id - 1)
    end

    # Complete a task with the given task_id
    #
    # Here we do have a bang (!) because List#complete could mean
    # many things.  Does it mean "complete this task?"  Does it mean
    # "give me all the complete tasks?"  This is unambiguous.
    def complete!(task_id)
      @tasks[task_id - 1].complete!
    end

    # Return an array of complete tasks sorted by completion date
    #
    # We don't need to store the complete tasks as a separate
    # instance variable inside List.  We can just create the list
    # when someone asks for it
    #
    # A situation where we might want to store an array of complete
    # and/or incomplete tasks is if we have lots of tasks in our list
    #
    # By doing a little bit of work each time someone marks a tasks
    # as complete, we can return the "cached" list when a user
    # asks for it, rather than re-computing in its entirety each time
    #
    # Until you have evidence that re-computing it each time is
    # a real bottleneck in your code, don't try to optimize it.
    #
    # Simple code is better than complex code, unless the complex code
    # ofers some real, tangible benefit over the simple code, e.g.,
    # it results in a user interface that's 100x more responsive
    #
    # See: http://c2.com/cgi/wiki?PrematureOptimization
    def complete_tasks
      results = []
      @tasks.each do |task|
        # It's bad form to write != nil
        # http://ruby-doc.org/core-1.9.3/Object.html#method-i-nil-3F

        if !task.completed_at.nil?
          results << task
        end
      end

      results.sort_by { |task| task.completed_at }
    end

    # Return an array of incomplete tasks sorted by creation date
    def incomplete_tasks
      results = []
      @tasks.each do |task|
        # It's bad form to write == nil
        if task.completed_at.nil?
          results << task
        end
      end

      results.sort_by { |task| task.created_at }
    end

    # A more DRY version of the above might be this.
    # 
    # Lots of people wrote code very similar to the above, though,
    # so I used that.  The fact that the two methods are so similar
    # should raise a yellow "refactor this" flag.
    #
    # def incomplete_tasks
    #   self.tasks - self.complete_tasks
    # end
  end
  
  class Task
    # Again, exposes readers but not writers
    # The world has no business modifying these things directly
    # except through the interfaces we define.
    #
    # Eventually we might want people to edit tasks, so exposing
    # a writer for @description would be reasonable
    #
    # Don't expose it until you need it.  You'll forget you did.
    attr_reader :description, :created_at, :completed_at
    
    # Some people prefer "short" variable names.  I don't know why.
    # 
    # IMO the priority is not terseness but clarity.  Variable names
    # should indicate their purpose. In everyday English you'd call 
    # the line-item on your personal  TODO list its description.  
    # We should call it that here, too.
    def initialize(description)
      @description = description
      
      @created_at   = Time.now
      @completed_at = nil
    end

    # Mark the task as completed
    def complete!
      @completed_at = Time.now
    end
  end
end