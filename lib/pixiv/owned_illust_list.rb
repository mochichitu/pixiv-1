module Pixiv
  # Illust list owned by a member
  #
  # @abstract
  #
  # Implements common methods for bookmark.php and member_illust.php.
  class OwnedIllustList < IllustList
    ILLUSTS_PER_PAGE = 20

    # Returns the URL for given +member_id+ and +page+
    # @param [Integer] member_id
    # @param [Integer] page
    # @return [String]
    def self.url(member_id, page = 1)
      raise NotImplementError
    end

    # @return [Integer]
    lazy_attr_reader(:page) {
      at!('li.pages-current').inner_text.to_i
    }
    # @return [Boolean]
    lazy_attr_reader(:last?) {
      at!('li.pages-current').next_element.inner_text.to_i == 0
    }
    # @return [Integer]
    lazy_attr_reader(:member_id) {
      doc.body[/pixiv\.context\.userId = '(\d+)'/, 1].to_i
    }

    # @return [String]
    def url
      self.class.url(member_id, page)
    end

    # @return [Boolean]
    def first?
      page == 1
    end

    # @return [String]
    def next_url
      last? ? nil : self.class.url(member_id, page + 1)
    end

    # @return [String]
    def prev_url
      first? ? nil : self.class.url(member_id, page - 1)
    end

    # @return [Integer]
    def max_size
      ILLUSTS_PER_PAGE
    end

    # @!parse alias owner_id member_id
    def owner_id; member_id end
  end

  module OwnedIllustList::WithClient
    include IllustList::WithClient

    # @return [Pixiv::Member]
    def member
      client.member(member_id)
    end

    # @!parse alias owner member
    def owner; member end
  end
end