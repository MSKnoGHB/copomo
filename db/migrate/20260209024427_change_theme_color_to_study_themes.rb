class ChangeThemeColorToStudyThemes < ActiveRecord::Migration[6.1]
  def change
    change_column :study_themes, :theme_color, :integer, default: 0
  end
end
