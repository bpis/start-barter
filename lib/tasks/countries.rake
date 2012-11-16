  namespace :db do

  desc "load countries data from csv"
  task :countries  => :environment do
    require 'csv'

    CSV.foreach("#{Rails.root}/lib/tasks/countries.csv", {:headers => true}) do |row|
      co = Country.create(:code => row[0], :name => row[1])
      puts "#{co.name} created."
    end
  end
end