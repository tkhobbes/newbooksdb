namespace :bookdb_prep do
  desc "Seeds a default bookformat"
  task seed_formats: :environment do
    unless BookFormat.where(fallback: true).any?
      if BookFormat.find_by(name: 'Default')
        BookFormat.find_by(name: 'Default').update(fallback: true)
      else
        BookFormat.create(name: 'Default', fallback: true)
      end
    end
  end
end
