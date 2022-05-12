class AddUserIdTasks < ActiveRecord::Migration[6.1]
  def up
    execute 'DeLETE FROM tasks;'
    add_reference :tasks, :user, null: false, index: true
  end

  def down
    remove_reference :tasks, :user, index: true
  end
end
