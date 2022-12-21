# frozen_string_literal: true

module HomeHelper
  # generate a hash of genres and their size
  # this method smells of :reek:TooManyStatements
  def genre_cloud
    cloud_data = []
    Genre.all.each do |genre|
      one_genre = {}
      one_genre[:name] = genre.name
      one_genre[:size] = genre.books_count
      one_genre[:id] = genre.id
      cloud_data << one_genre
    end
    cloud_data
  end

  # map actual sizes to manageable sizes (10 buckets)
  def cloudsize(a_size, maxsize)
    # size is the ratio rounded up to the next tenth (15 --> 10, 21 --> 20 etc)
    # and then size is divided by 10 to get the bucket
    (a_size / maxsize.to_f * 100).round.to_i.ceil(-1) / 10
  end
end
