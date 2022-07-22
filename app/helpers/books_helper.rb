# Standard Rails helper module
module BooksHelper

  # returns the original title of a book in brackets if it is available
  # @return [String] (original title in brackets)
  def original_title(book)
    if book.original_title.present?
      "(" + book.original_title + ")"
    end
  end

  # returns either the cover image of a book or a placeholder SVG
  # @return [String] (HTML image tag or SVG tag)
  def cover_image(book)
    if book.cover.attached?
      image_tag book.cover.variant(resize_to_limit: [500, 500])
    else
      content_tag(
        :svg,
        xlmns: "http://www.w3.org/2000/svg",
        class: "placeholder",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2"
      ) do
        tag(
          :path,
          "stroke-linecap": "round",
          "stroke-linejoin": "round",
          d: "M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"
        )
      end
    end
  end

  # returns span tags with filled stars equal to the rating and empty stars to fill up to 5
  # @return [String] (HTML span tags)
  def rating_stars(rating)
    content_tag(:span, class: "color-accent") do
      content_tag(
        :svg,
        xlmns: "http://www.w3.org/2000/svg",
        class: "smallicon",
        viewBox: "0 0 24 24",
        fill: "currentColor",
        stroke: "currentColor",
        "stroke-width": "1") do
          tag(
            :path,
            d: "M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"
          )
      end * rating <<
      content_tag(
        :svg,
        xmlns: "http://www.w3.org/2000/svg",
        class: "smallicon",
        fill: "none",
        viewBox: "0 0 24 24",
        stroke: "currentColor",
        "stroke-width": "1") do
          tag(
            :path,
            "stroke-linecap": "round",
            "stroke-linejoin": "round",
            d: "M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"
          )
        end * (5- rating)
    end
  end
end
