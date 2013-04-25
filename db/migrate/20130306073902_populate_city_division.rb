class PopulateCityDivision < ActiveRecord::Migration
  def up
    Rake::Task['populate:city_division'].invoke
  end

  def down
    CityDivision.destroy_all
  end
end
