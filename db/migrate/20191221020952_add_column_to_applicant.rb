class AddColumnToApplicant < ActiveRecord::Migration[6.0]
  def change
    add_column :applicants, :achieved, :boolean, default: false, null:false
  end
end
