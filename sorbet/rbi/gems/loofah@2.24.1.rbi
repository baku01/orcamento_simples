# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `loofah` gem.
# Please instead update this file by running `bin/tapioca gem loofah`.


# == Strings and IO Objects as Input
#
# The following methods accept any IO object in addition to accepting a string:
#
# - Loofah.html4_document
# - Loofah.html4_fragment
# - Loofah.scrub_html4_document
# - Loofah.scrub_html4_fragment
#
# - Loofah.html5_document
# - Loofah.html5_fragment
# - Loofah.scrub_html5_document
# - Loofah.scrub_html5_fragment
#
# - Loofah.xml_document
# - Loofah.xml_fragment
# - Loofah.scrub_xml_document
# - Loofah.scrub_xml_fragment
#
# - Loofah.document
# - Loofah.fragment
# - Loofah.scrub_document
# - Loofah.scrub_fragment
#
# That IO object could be a file, or a socket, or a StringIO, or anything that responds to +read+
# and +close+.
#
# source://loofah//lib/loofah.rb#5
module Loofah
  class << self
    # Shortcut for Loofah::HTML4::Document.parse(*args, &block)
    #
    # This method accepts the same parameters as Nokogiri::HTML4::Document.parse
    #
    # source://loofah//lib/loofah.rb#139
    def document(*args, &block); end

    # Shortcut for Loofah::HTML4::DocumentFragment.parse(*args, &block)
    #
    # This method accepts the same parameters as Nokogiri::HTML4::DocumentFragment.parse
    #
    # source://loofah//lib/loofah.rb#140
    def fragment(*args, &block); end

    # Shortcut for Loofah::HTML4::Document.parse(*args, &block)
    #
    # This method accepts the same parameters as Nokogiri::HTML4::Document.parse
    #
    # source://loofah//lib/loofah.rb#76
    def html4_document(*args, &block); end

    # Shortcut for Loofah::HTML4::DocumentFragment.parse(*args, &block)
    #
    # This method accepts the same parameters as Nokogiri::HTML4::DocumentFragment.parse
    #
    # source://loofah//lib/loofah.rb#83
    def html4_fragment(*args, &block); end

    # source://loofah//lib/loofah.rb#101
    def html5_document(*args, &block); end

    # source://loofah//lib/loofah.rb#108
    def html5_fragment(*args, &block); end

    # @return [Boolean]
    #
    # source://loofah//lib/loofah.rb#7
    def html5_support?; end

    # A helper to remove extraneous whitespace from text-ified HTML
    #
    # source://loofah//lib/loofah.rb#169
    def remove_extraneous_whitespace(string); end

    # Shortcut for Loofah::HTML4::Document.parse(string_or_io).scrub!(method)
    #
    # source://loofah//lib/loofah.rb#141
    def scrub_document(string_or_io, method); end

    # Shortcut for Loofah::HTML4::DocumentFragment.parse(string_or_io).scrub!(method)
    #
    # source://loofah//lib/loofah.rb#142
    def scrub_fragment(string_or_io, method); end

    # Shortcut for Loofah::HTML4::Document.parse(string_or_io).scrub!(method)
    #
    # source://loofah//lib/loofah.rb#88
    def scrub_html4_document(string_or_io, method); end

    # Shortcut for Loofah::HTML4::DocumentFragment.parse(string_or_io).scrub!(method)
    #
    # source://loofah//lib/loofah.rb#93
    def scrub_html4_fragment(string_or_io, method); end

    # source://loofah//lib/loofah.rb#113
    def scrub_html5_document(string_or_io, method); end

    # source://loofah//lib/loofah.rb#118
    def scrub_html5_fragment(string_or_io, method); end

    # Shortcut for Loofah.xml_document(string_or_io).scrub!(method)
    #
    # source://loofah//lib/loofah.rb#164
    def scrub_xml_document(string_or_io, method); end

    # Shortcut for Loofah.xml_fragment(string_or_io).scrub!(method)
    #
    # source://loofah//lib/loofah.rb#159
    def scrub_xml_fragment(string_or_io, method); end

    # Shortcut for Loofah::XML::Document.parse(*args, &block)
    #
    # This method accepts the same parameters as Nokogiri::XML::Document.parse
    #
    # source://loofah//lib/loofah.rb#147
    def xml_document(*args, &block); end

    # Shortcut for Loofah::XML::DocumentFragment.parse(*args, &block)
    #
    # This method accepts the same parameters as Nokogiri::XML::DocumentFragment.parse
    #
    # source://loofah//lib/loofah.rb#154
    def xml_fragment(*args, &block); end
  end
end

# source://loofah//lib/loofah/concerns.rb#125
module Loofah::DocumentDecorator
  # source://loofah//lib/loofah/concerns.rb#126
  def initialize(*args, &block); end
end

# source://loofah//lib/loofah/elements.rb#6
module Loofah::Elements; end

# source://loofah//lib/loofah/elements.rb#93
Loofah::Elements::BLOCK_LEVEL = T.let(T.unsafe(nil), Set)

# Elements that aren't block but should generate a newline in #to_text
#
# source://loofah//lib/loofah/elements.rb#90
Loofah::Elements::INLINE_LINE_BREAK = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/elements.rb#94
Loofah::Elements::LINEBREAKERS = T.let(T.unsafe(nil), Set)

# The following elements may also be considered block-level
# elements since they may contain block-level elements
#
# source://loofah//lib/loofah/elements.rb#76
Loofah::Elements::LOOSE_BLOCK_LEVEL = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/elements.rb#92
Loofah::Elements::STRICT_BLOCK_LEVEL = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/elements.rb#7
Loofah::Elements::STRICT_BLOCK_LEVEL_HTML4 = T.let(T.unsafe(nil), Set)

# https://developer.mozilla.org/en-US/docs/Web/HTML/Block-level_elements
#
# source://loofah//lib/loofah/elements.rb#35
Loofah::Elements::STRICT_BLOCK_LEVEL_HTML5 = T.let(T.unsafe(nil), Set)

# Alias for Loofah::HTML4
#
# source://loofah//lib/loofah.rb#70
Loofah::HTML = Loofah::HTML4

# source://loofah//lib/loofah/html4/document.rb#4
module Loofah::HTML4; end

# Subclass of Nokogiri::HTML4::Document.
#
#  See Loofah::ScrubBehavior and Loofah::TextBehavior for additional methods.
#
# source://loofah//lib/loofah/html4/document.rb#10
class Loofah::HTML4::Document < ::Nokogiri::HTML4::Document
  include ::Loofah::ScrubBehavior::Node
  include ::Loofah::DocumentDecorator
  include ::Loofah::TextBehavior
  include ::Loofah::HtmlDocumentBehavior
  extend ::Loofah::HtmlDocumentBehavior::ClassMethods
end

# Subclass of Nokogiri::HTML4::DocumentFragment.
#
#  See Loofah::ScrubBehavior and Loofah::TextBehavior for additional methods.
#
# source://loofah//lib/loofah/html4/document_fragment.rb#10
class Loofah::HTML4::DocumentFragment < ::Nokogiri::HTML4::DocumentFragment
  include ::Loofah::TextBehavior
  include ::Loofah::HtmlFragmentBehavior
  extend ::Loofah::HtmlFragmentBehavior::ClassMethods
end

# source://loofah//lib/loofah/html5/safelist.rb#6
module Loofah::HTML5; end

# Subclass of Nokogiri::HTML5::Document.
#
#  See Loofah::ScrubBehavior and Loofah::TextBehavior for additional methods.
#
# source://loofah//lib/loofah/html5/document.rb#10
class Loofah::HTML5::Document < ::Nokogiri::HTML5::Document
  include ::Loofah::ScrubBehavior::Node
  include ::Loofah::DocumentDecorator
  include ::Loofah::TextBehavior
  include ::Loofah::HtmlDocumentBehavior
  extend ::Loofah::HtmlDocumentBehavior::ClassMethods
end

# Subclass of Nokogiri::HTML5::DocumentFragment.
#
#  See Loofah::ScrubBehavior and Loofah::TextBehavior for additional methods.
#
# source://loofah//lib/loofah/html5/document_fragment.rb#10
class Loofah::HTML5::DocumentFragment < ::Nokogiri::HTML5::DocumentFragment
  include ::Loofah::TextBehavior
  include ::Loofah::HtmlFragmentBehavior
  extend ::Loofah::HtmlFragmentBehavior::ClassMethods
end

# source://loofah//lib/loofah/html5/safelist.rb#49
module Loofah::HTML5::SafeList; end

# source://loofah//lib/loofah/html5/safelist.rb#232
Loofah::HTML5::SafeList::ACCEPTABLE_ATTRIBUTES = T.let(T.unsafe(nil), Set)

# https://www.w3.org/TR/css-color-3/#html4
#
# source://loofah//lib/loofah/html5/safelist.rb#738
Loofah::HTML5::SafeList::ACCEPTABLE_CSS_COLORS = T.let(T.unsafe(nil), Set)

# https://www.w3.org/TR/css-color-3/#svg-color
#
# source://loofah//lib/loofah/html5/safelist.rb#758
Loofah::HTML5::SafeList::ACCEPTABLE_CSS_EXTENDED_COLORS = T.let(T.unsafe(nil), Set)

# see https://www.quackit.com/css/functions/
# omit `url` and `image` from that list
#
# source://loofah//lib/loofah/html5/safelist.rb#910
Loofah::HTML5::SafeList::ACCEPTABLE_CSS_FUNCTIONS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#699
Loofah::HTML5::SafeList::ACCEPTABLE_CSS_KEYWORDS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#626
Loofah::HTML5::SafeList::ACCEPTABLE_CSS_PROPERTIES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#50
Loofah::HTML5::SafeList::ACCEPTABLE_ELEMENTS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#983
Loofah::HTML5::SafeList::ACCEPTABLE_PROTOCOLS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#970
Loofah::HTML5::SafeList::ACCEPTABLE_SVG_PROPERTIES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1014
Loofah::HTML5::SafeList::ACCEPTABLE_URI_DATA_MEDIATYPES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1024
Loofah::HTML5::SafeList::ALLOWED_ATTRIBUTES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1027
Loofah::HTML5::SafeList::ALLOWED_CSS_FUNCTIONS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1026
Loofah::HTML5::SafeList::ALLOWED_CSS_KEYWORDS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1025
Loofah::HTML5::SafeList::ALLOWED_CSS_PROPERTIES = T.let(T.unsafe(nil), Set)

# subclasses may define their own versions of these constants
#
# source://loofah//lib/loofah/html5/safelist.rb#1023
Loofah::HTML5::SafeList::ALLOWED_ELEMENTS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1048
Loofah::HTML5::SafeList::ALLOWED_ELEMENTS_WITH_LIBXML2 = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1029
Loofah::HTML5::SafeList::ALLOWED_PROTOCOLS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1028
Loofah::HTML5::SafeList::ALLOWED_SVG_PROPERTIES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#1030
Loofah::HTML5::SafeList::ALLOWED_URI_DATA_MEDIATYPES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#526
Loofah::HTML5::SafeList::ARIA_ATTRIBUTES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#582
Loofah::HTML5::SafeList::ATTR_VAL_IS_URI = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#315
Loofah::HTML5::SafeList::MATHML_ATTRIBUTES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#147
Loofah::HTML5::SafeList::MATHML_ELEMENTS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#981
Loofah::HTML5::SafeList::PROTOCOL_SEPARATOR = T.let(T.unsafe(nil), Regexp)

# source://loofah//lib/loofah/html5/safelist.rb#963
Loofah::HTML5::SafeList::SHORTHAND_CSS_PROPERTIES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#608
Loofah::HTML5::SafeList::SVG_ALLOW_LOCAL_HREF = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#367
Loofah::HTML5::SafeList::SVG_ATTRIBUTES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#594
Loofah::HTML5::SafeList::SVG_ATTR_VAL_ALLOWS_REF = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/safelist.rb#183
Loofah::HTML5::SafeList::SVG_ELEMENTS = T.let(T.unsafe(nil), Set)

# additional tags we should consider safe since we have libxml2 fixing up our documents.
#
# source://loofah//lib/loofah/html5/safelist.rb#1043
Loofah::HTML5::SafeList::TAGS_SAFE_WITH_LIBXML2 = T.let(T.unsafe(nil), Set)

# TODO: remove VOID_ELEMENTS in a future major release
# and put it in the tests (it is used only for testing, not for functional behavior)
#
# source://loofah//lib/loofah/html5/safelist.rb#1034
Loofah::HTML5::SafeList::VOID_ELEMENTS = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/scrub.rb#9
module Loofah::HTML5::Scrub
  class << self
    # @return [Boolean]
    #
    # source://loofah//lib/loofah/html5/scrub.rb#19
    def allowed_element?(element_name); end

    # source://loofah//lib/loofah/html5/scrub.rb#193
    def cdata_escape(node); end

    # @return [Boolean]
    #
    # source://loofah//lib/loofah/html5/scrub.rb#188
    def cdata_needs_escaping?(node); end

    # source://loofah//lib/loofah/html5/scrub.rb#208
    def escape_tags(string); end

    # libxml2 >= 2.9.2 fails to escape comments within some attributes.
    #
    #  see comments about CVE-2018-8048 within the tests for more information
    #
    # source://loofah//lib/loofah/html5/scrub.rb#167
    def force_correct_attribute_escaping!(node); end

    # source://loofah//lib/loofah/html5/scrub.rb#124
    def scrub_attribute_that_allows_local_ref(attr_node); end

    # alternative implementation of the html5lib attribute scrubbing algorithm
    #
    # source://loofah//lib/loofah/html5/scrub.rb#24
    def scrub_attributes(node); end

    # source://loofah//lib/loofah/html5/scrub.rb#73
    def scrub_css(style); end

    # source://loofah//lib/loofah/html5/scrub.rb#68
    def scrub_css_attribute(node); end

    # source://loofah//lib/loofah/html5/scrub.rb#143
    def scrub_uri_attribute(attr_node); end
  end
end

# source://loofah//lib/loofah/html5/scrub.rb#10
Loofah::HTML5::Scrub::CONTROL_CHARACTERS = T.let(T.unsafe(nil), Regexp)

# source://loofah//lib/loofah/html5/scrub.rb#12
Loofah::HTML5::Scrub::CRASS_SEMICOLON = T.let(T.unsafe(nil), Hash)

# source://loofah//lib/loofah/html5/scrub.rb#13
Loofah::HTML5::Scrub::CSS_IMPORTANT = T.let(T.unsafe(nil), String)

# source://loofah//lib/loofah/html5/scrub.rb#11
Loofah::HTML5::Scrub::CSS_KEYWORDISH = T.let(T.unsafe(nil), Regexp)

# source://loofah//lib/loofah/html5/scrub.rb#15
Loofah::HTML5::Scrub::CSS_PROPERTY_STRING_WITHOUT_EMBEDDED_QUOTES = T.let(T.unsafe(nil), Regexp)

# source://loofah//lib/loofah/html5/scrub.rb#14
Loofah::HTML5::Scrub::CSS_WHITESPACE = T.let(T.unsafe(nil), String)

# source://loofah//lib/loofah/html5/scrub.rb#16
Loofah::HTML5::Scrub::DATA_ATTRIBUTE_NAME = T.let(T.unsafe(nil), Regexp)

# source://loofah//lib/loofah/html5/safelist.rb#1051
Loofah::HTML5::WhiteList = Loofah::HTML5::SafeList

# source://loofah//lib/loofah/concerns.rb#133
module Loofah::HtmlDocumentBehavior
  mixes_in_class_methods ::Loofah::HtmlDocumentBehavior::ClassMethods

  # source://loofah//lib/loofah/concerns.rb#164
  def serialize_root; end

  class << self
    # @private
    #
    # source://loofah//lib/loofah/concerns.rb#159
    def included(base); end
  end
end

# source://loofah//lib/loofah/concerns.rb#134
module Loofah::HtmlDocumentBehavior::ClassMethods
  # source://loofah//lib/loofah/concerns.rb#135
  def parse(*args, &block); end

  private

  # remove comments that exist outside of the HTML element.
  #
  # these comments are allowed by the HTML spec:
  #
  #    https://www.w3.org/TR/html401/struct/global.html#h-7.1
  #
  # but are not scrubbed by Loofah because these nodes don't meet
  # the contract that scrubbers expect of a node (e.g., it can be
  # replaced, sibling and children nodes can be created).
  #
  # source://loofah//lib/loofah/concerns.rb#150
  def remove_comments_before_html_element(doc); end
end

# source://loofah//lib/loofah/concerns.rb#169
module Loofah::HtmlFragmentBehavior
  mixes_in_class_methods ::Loofah::HtmlFragmentBehavior::ClassMethods

  # source://loofah//lib/loofah/concerns.rb#201
  def serialize; end

  # source://loofah//lib/loofah/concerns.rb#203
  def serialize_root; end

  # source://loofah//lib/loofah/concerns.rb#197
  def to_s; end

  class << self
    # @private
    #
    # source://loofah//lib/loofah/concerns.rb#192
    def included(base); end
  end
end

# source://loofah//lib/loofah/concerns.rb#170
module Loofah::HtmlFragmentBehavior::ClassMethods
  # source://loofah//lib/loofah/concerns.rb#180
  def document_klass; end

  # source://loofah//lib/loofah/concerns.rb#171
  def parse(tags, encoding = T.unsafe(nil)); end
end

# constants related to working around unhelpful libxml2 behavior
#
#  ಠ_ಠ
#
# source://loofah//lib/loofah/html5/libxml2_workarounds.rb#12
module Loofah::LibxmlWorkarounds; end

# these attributes and qualifying parent tags are determined by the code at:
#
#    https://git.gnome.org/browse/libxml2/tree/HTMLtree.c?h=v2.9.2#n714
#
#  see comments about CVE-2018-8048 within the tests for more information
#
# source://loofah//lib/loofah/html5/libxml2_workarounds.rb#20
Loofah::LibxmlWorkarounds::BROKEN_ESCAPING_ATTRIBUTES = T.let(T.unsafe(nil), Set)

# source://loofah//lib/loofah/html5/libxml2_workarounds.rb#26
Loofah::LibxmlWorkarounds::BROKEN_ESCAPING_ATTRIBUTES_QUALIFYING_TAG = T.let(T.unsafe(nil), Hash)

# source://loofah//lib/loofah/metahelpers.rb#4
module Loofah::MetaHelpers
  class << self
    # source://loofah//lib/loofah/metahelpers.rb#6
    def add_downcased_set_members_to_all_set_constants(mojule); end
  end
end

# Mixes +scrub!+ into Document, DocumentFragment, Node and NodeSet.
#
#  Traverse the document or fragment, invoking the +scrubber+ on each node.
#
#  +scrubber+ must either be one of the symbols representing the built-in scrubbers (see
#  Scrubbers), or a Scrubber instance.
#
#    span2div = Loofah::Scrubber.new do |node|
#      node.name = "div" if node.name == "span"
#    end
#    Loofah.html5_fragment("<span>foo</span><p>bar</p>").scrub!(span2div).to_s
#    # => "<div>foo</div><p>bar</p>"
#
#  or
#
#    unsafe_html = "ohai! <div>div is safe</div> <script>but script is not</script>"
#    Loofah.html5_fragment(unsafe_html).scrub!(:strip).to_s
#    # => "ohai! <div>div is safe</div> "
#
#  Note that this method is called implicitly from the shortcuts Loofah.scrub_html5_fragment et
#  al.
#
#  Please see Scrubber for more information on implementation and traversal, and README.rdoc for
#  more example usage.
#
# source://loofah//lib/loofah/concerns.rb#30
module Loofah::ScrubBehavior
  class << self
    # source://loofah//lib/loofah/concerns.rb#59
    def resolve_scrubber(scrubber); end
  end
end

# source://loofah//lib/loofah/concerns.rb#31
module Loofah::ScrubBehavior::Node
  # source://loofah//lib/loofah/concerns.rb#32
  def scrub!(scrubber); end
end

# source://loofah//lib/loofah/concerns.rb#51
module Loofah::ScrubBehavior::NodeSet
  # source://loofah//lib/loofah/concerns.rb#52
  def scrub!(scrubber); end
end

# A Scrubber wraps up a block (or method) that is run on an HTML node (element):
#
#    # change all <span> tags to <div> tags
#    span2div = Loofah::Scrubber.new do |node|
#      node.name = "div" if node.name == "span"
#    end
#
#  Alternatively, this scrubber could have been implemented as:
#
#    class Span2Div < Loofah::Scrubber
#      def scrub(node)
#        node.name = "div" if node.name == "span"
#      end
#    end
#    span2div = Span2Div.new
#
#  This can then be run on a document:
#
#    Loofah.html5_fragment("<span>foo</span><p>bar</p>").scrub!(span2div).to_s
#    # => "<div>foo</div><p>bar</p>"
#
#  Scrubbers can be run on a document in either a top-down traversal (the
#  default) or bottom-up. Top-down scrubbers can optionally return
#  Scrubber::STOP to terminate the traversal of a subtree.
#
# source://loofah//lib/loofah/scrubber.rb#35
class Loofah::Scrubber
  # Options may include
  #    :direction => :top_down (the default)
  #  or
  #    :direction => :bottom_up
  #
  #  For top_down traversals, if the block returns
  #  Loofah::Scrubber::STOP, then the traversal will be terminated
  #  for the current node's subtree.
  #
  #  Alternatively, a Scrubber may inherit from Loofah::Scrubber,
  #  and implement +scrub+, which is slightly faster than using a
  #  block.
  #
  # @return [Scrubber] a new instance of Scrubber
  #
  # source://loofah//lib/loofah/scrubber.rb#65
  def initialize(options = T.unsafe(nil), &block); end

  # If the attribute is not set, add it
  # If the attribute is set, don't overwrite the existing value
  #
  # source://loofah//lib/loofah/scrubber.rb#96
  def append_attribute(node, attribute, value); end

  # When a scrubber is initialized, the optional block is saved as
  # :block. Note that, if no block is passed, then the +scrub+
  # method is assumed to have been implemented.
  #
  # source://loofah//lib/loofah/scrubber.rb#49
  def block; end

  # When a scrubber is initialized, the :direction may be specified
  # as :top_down (the default) or :bottom_up.
  #
  # source://loofah//lib/loofah/scrubber.rb#44
  def direction; end

  # When +new+ is not passed a block, the class may implement
  #  +scrub+, which will be called for each document node.
  #
  # @raise [ScrubberNotFound]
  #
  # source://loofah//lib/loofah/scrubber.rb#88
  def scrub(node); end

  # Calling +traverse+ will cause the document to be traversed by
  #  either the lambda passed to the initializer or the +scrub+
  #  method, in the direction specified at +new+ time.
  #
  # source://loofah//lib/loofah/scrubber.rb#80
  def traverse(node); end

  private

  # source://loofah//lib/loofah/scrubber.rb#105
  def html5lib_sanitize(node); end

  # source://loofah//lib/loofah/scrubber.rb#131
  def traverse_conditionally_bottom_up(node); end

  # source://loofah//lib/loofah/scrubber.rb#122
  def traverse_conditionally_top_down(node); end
end

# Top-down Scrubbers may return CONTINUE to indicate that the subtree should be traversed.
#
# source://loofah//lib/loofah/scrubber.rb#37
Loofah::Scrubber::CONTINUE = T.let(T.unsafe(nil), Object)

# Top-down Scrubbers may return STOP to indicate that the subtree should not be traversed.
#
# source://loofah//lib/loofah/scrubber.rb#40
Loofah::Scrubber::STOP = T.let(T.unsafe(nil), Object)

# A RuntimeError raised when Loofah could not find an appropriate scrubber.
#
# source://loofah//lib/loofah/scrubber.rb#7
class Loofah::ScrubberNotFound < ::RuntimeError; end

# Loofah provides some built-in scrubbers for sanitizing with
#  HTML5lib's safelist and for accomplishing some common
#  transformation tasks.
#
#
#  === Loofah::Scrubbers::Strip / scrub!(:strip)
#
#  +:strip+ removes unknown/unsafe tags, but leaves behind the pristine contents:
#
#     unsafe_html = "ohai! <div>div is safe</div> <foo>but foo is <b>not</b></foo>"
#     Loofah.html5_fragment(unsafe_html).scrub!(:strip)
#     => "ohai! <div>div is safe</div> but foo is <b>not</b>"
#
#
#  === Loofah::Scrubbers::Prune / scrub!(:prune)
#
#  +:prune+ removes unknown/unsafe tags and their contents (including their subtrees):
#
#     unsafe_html = "ohai! <div>div is safe</div> <foo>but foo is <b>not</b></foo>"
#     Loofah.html5_fragment(unsafe_html).scrub!(:prune)
#     => "ohai! <div>div is safe</div> "
#
#
#  === Loofah::Scrubbers::Escape / scrub!(:escape)
#
#  +:escape+ performs HTML entity escaping on the unknown/unsafe tags:
#
#     unsafe_html = "ohai! <div>div is safe</div> <foo>but foo is <b>not</b></foo>"
#     Loofah.html5_fragment(unsafe_html).scrub!(:escape)
#     => "ohai! <div>div is safe</div> &lt;foo&gt;but foo is &lt;b&gt;not&lt;/b&gt;&lt;/foo&gt;"
#
#
#  === Loofah::Scrubbers::Whitewash / scrub!(:whitewash)
#
#  +:whitewash+ removes all comments, styling and attributes in
#  addition to doing markup-fixer-uppery and pruning unsafe tags. I
#  like to call this "whitewashing", since it's like putting a new
#  layer of paint on top of the HTML input to make it look nice.
#
#     messy_markup = "ohai! <div id='foo' class='bar' style='margin: 10px'>div with attributes</div>"
#     Loofah.html5_fragment(messy_markup).scrub!(:whitewash)
#     => "ohai! <div>div with attributes</div>"
#
#  One use case for this scrubber is to clean up HTML that was
#  cut-and-pasted from Microsoft Word into a WYSIWYG editor or a
#  rich text editor. Microsoft's software is famous for injecting
#  all kinds of cruft into its HTML output. Who needs that crap?
#  Certainly not me.
#
#
#  === Loofah::Scrubbers::NoFollow / scrub!(:nofollow)
#
#  +:nofollow+ adds a rel="nofollow" attribute to all links
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:nofollow)
#     => "ohai! <a href='http://www.myswarmysite.com/' rel="nofollow">I like your blog post</a>"
#
#
#  === Loofah::Scrubbers::TargetBlank / scrub!(:targetblank)
#
#  +:targetblank+ adds a target="_blank" attribute to all links
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:targetblank)
#     => "ohai! <a href='http://www.myswarmysite.com/' target="_blank">I like your blog post</a>"
#
#
#  === Loofah::Scrubbers::NoOpener / scrub!(:noopener)
#
#  +:noopener+ adds a rel="noopener" attribute to all links
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:noopener)
#     => "ohai! <a href='http://www.myswarmysite.com/' rel="noopener">I like your blog post</a>"
#
#  === Loofah::Scrubbers::NoReferrer / scrub!(:noreferrer)
#
#  +:noreferrer+ adds a rel="noreferrer" attribute to all links
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:noreferrer)
#     => "ohai! <a href='http://www.myswarmysite.com/' rel="noreferrer">I like your blog post</a>"
#
#
#  === Loofah::Scrubbers::Unprintable / scrub!(:unprintable)
#
#  +:unprintable+ removes unprintable Unicode characters.
#
#     markup = "<p>Some text with an unprintable character at the end\u2028</p>"
#     Loofah.html5_fragment(markup).scrub!(:unprintable)
#     => "<p>Some text with an unprintable character at the end</p>"
#
#  You may not be able to see the unprintable character in the above example, but there is a
#  U+2028 character right before the closing </p> tag. These characters can cause issues if
#  the content is ever parsed by JavaScript - more information here:
#
#     http://timelessrepo.com/json-isnt-a-javascript-subset
#
# source://loofah//lib/loofah/scrubbers.rb#104
module Loofah::Scrubbers
  class << self
    # Returns an array of symbols representing the built-in scrubbers
    #
    # source://loofah//lib/loofah/scrubbers.rb#425
    def scrubber_symbols; end
  end
end

# === scrub!(:double_breakpoint)
#
#  +:double_breakpoint+ replaces double-break tags with closing/opening paragraph tags.
#
#     markup = "<p>Some text here in a logical paragraph.<br><br>Some more text, apparently a second paragraph.</p>"
#     Loofah.html5_fragment(markup).scrub!(:double_breakpoint)
#     => "<p>Some text here in a logical paragraph.</p><p>Some more text, apparently a second paragraph.</p>"
#
# source://loofah//lib/loofah/scrubbers.rb#362
class Loofah::Scrubbers::DoubleBreakpoint < ::Loofah::Scrubber
  # @return [DoubleBreakpoint] a new instance of DoubleBreakpoint
  #
  # source://loofah//lib/loofah/scrubbers.rb#363
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#367
  def scrub(node); end

  private

  # source://loofah//lib/loofah/scrubbers.rb#400
  def remove_blank_text_nodes(node); end
end

# === scrub!(:escape)
#
#  +:escape+ performs HTML entity escaping on the unknown/unsafe tags:
#
#     unsafe_html = "ohai! <div>div is safe</div> <foo>but foo is <b>not</b></foo>"
#     Loofah.html5_fragment(unsafe_html).scrub!(:escape)
#     => "ohai! <div>div is safe</div> &lt;foo&gt;but foo is &lt;b&gt;not&lt;/b&gt;&lt;/foo&gt;"
#
# source://loofah//lib/loofah/scrubbers.rb#159
class Loofah::Scrubbers::Escape < ::Loofah::Scrubber
  # @return [Escape] a new instance of Escape
  #
  # source://loofah//lib/loofah/scrubbers.rb#160
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#164
  def scrub(node); end
end

# A hash that maps a symbol (like +:prune+) to the appropriate Scrubber (Loofah::Scrubbers::Prune).
#
# source://loofah//lib/loofah/scrubbers.rb#407
Loofah::Scrubbers::MAP = T.let(T.unsafe(nil), Hash)

# This class probably isn't useful publicly, but is used for #to_text's current implemention
#
# source://loofah//lib/loofah/scrubbers.rb#307
class Loofah::Scrubbers::NewlineBlockElements < ::Loofah::Scrubber
  # @return [NewlineBlockElements] a new instance of NewlineBlockElements
  #
  # source://loofah//lib/loofah/scrubbers.rb#308
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#312
  def scrub(node); end
end

# === scrub!(:nofollow)
#
#  +:nofollow+ adds a rel="nofollow" attribute to all links
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:nofollow)
#     => "ohai! <a href='http://www.myswarmysite.com/' rel="nofollow">I like your blog post</a>"
#
# source://loofah//lib/loofah/scrubbers.rb#220
class Loofah::Scrubbers::NoFollow < ::Loofah::Scrubber
  # @return [NoFollow] a new instance of NoFollow
  #
  # source://loofah//lib/loofah/scrubbers.rb#221
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#225
  def scrub(node); end
end

# === scrub!(:noopener)
#
#  +:noopener+ adds a rel="noopener" attribute to all links
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:noopener)
#     => "ohai! <a href='http://www.myswarmysite.com/' rel="noopener">I like your blog post</a>"
#
# source://loofah//lib/loofah/scrubbers.rb#271
class Loofah::Scrubbers::NoOpener < ::Loofah::Scrubber
  # @return [NoOpener] a new instance of NoOpener
  #
  # source://loofah//lib/loofah/scrubbers.rb#272
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#276
  def scrub(node); end
end

# === scrub!(:noreferrer)
#
#  +:noreferrer+ adds a rel="noreferrer" attribute to all links
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:noreferrer)
#     => "ohai! <a href='http://www.myswarmysite.com/' rel="noreferrer">I like your blog post</a>"
#
# source://loofah//lib/loofah/scrubbers.rb#293
class Loofah::Scrubbers::NoReferrer < ::Loofah::Scrubber
  # @return [NoReferrer] a new instance of NoReferrer
  #
  # source://loofah//lib/loofah/scrubbers.rb#294
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#298
  def scrub(node); end
end

# === scrub!(:prune)
#
#  +:prune+ removes unknown/unsafe tags and their contents (including their subtrees):
#
#     unsafe_html = "ohai! <div>div is safe</div> <foo>but foo is <b>not</b></foo>"
#     Loofah.html5_fragment(unsafe_html).scrub!(:prune)
#     => "ohai! <div>div is safe</div> "
#
# source://loofah//lib/loofah/scrubbers.rb#137
class Loofah::Scrubbers::Prune < ::Loofah::Scrubber
  # @return [Prune] a new instance of Prune
  #
  # source://loofah//lib/loofah/scrubbers.rb#138
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#142
  def scrub(node); end
end

# === scrub!(:strip)
#
#  +:strip+ removes unknown/unsafe tags, but leaves behind the pristine contents:
#
#     unsafe_html = "ohai! <div>div is safe</div> <foo>but foo is <b>not</b></foo>"
#     Loofah.html5_fragment(unsafe_html).scrub!(:strip)
#     => "ohai! <div>div is safe</div> but foo is <b>not</b>"
#
# source://loofah//lib/loofah/scrubbers.rb#114
class Loofah::Scrubbers::Strip < ::Loofah::Scrubber
  # @return [Strip] a new instance of Strip
  #
  # source://loofah//lib/loofah/scrubbers.rb#115
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#119
  def scrub(node); end
end

# === scrub!(:targetblank)
#
#  +:targetblank+ adds a target="_blank" attribute to all links.
#  If there is a target already set, replaces it with target="_blank".
#
#     link_farmers_markup = "ohai! <a href='http://www.myswarmysite.com/'>I like your blog post</a>"
#     Loofah.html5_fragment(link_farmers_markup).scrub!(:targetblank)
#     => "ohai! <a href='http://www.myswarmysite.com/' target="_blank">I like your blog post</a>"
#
#  On modern browsers, setting target="_blank" on anchor elements implicitly provides the same
#  behavior as setting rel="noopener".
#
# source://loofah//lib/loofah/scrubbers.rb#246
class Loofah::Scrubbers::TargetBlank < ::Loofah::Scrubber
  # @return [TargetBlank] a new instance of TargetBlank
  #
  # source://loofah//lib/loofah/scrubbers.rb#247
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#251
  def scrub(node); end
end

# === scrub!(:unprintable)
#
#  +:unprintable+ removes unprintable Unicode characters.
#
#     markup = "<p>Some text with an unprintable character at the end\u2028</p>"
#     Loofah.html5_fragment(markup).scrub!(:unprintable)
#     => "<p>Some text with an unprintable character at the end</p>"
#
#  You may not be able to see the unprintable character in the above example, but there is a
#  U+2028 character right before the closing </p> tag. These characters can cause issues if
#  the content is ever parsed by JavaScript - more information here:
#
#     http://timelessrepo.com/json-isnt-a-javascript-subset
#
# source://loofah//lib/loofah/scrubbers.rb#340
class Loofah::Scrubbers::Unprintable < ::Loofah::Scrubber
  # @return [Unprintable] a new instance of Unprintable
  #
  # source://loofah//lib/loofah/scrubbers.rb#341
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#345
  def scrub(node); end
end

# === scrub!(:whitewash)
#
#  +:whitewash+ removes all comments, styling and attributes in
#  addition to doing markup-fixer-uppery and pruning unsafe tags. I
#  like to call this "whitewashing", since it's like putting a new
#  layer of paint on top of the HTML input to make it look nice.
#
#     messy_markup = "ohai! <div id='foo' class='bar' style='margin: 10px'>div with attributes</div>"
#     Loofah.html5_fragment(messy_markup).scrub!(:whitewash)
#     => "ohai! <div>div with attributes</div>"
#
#  One use case for this scrubber is to clean up HTML that was
#  cut-and-pasted from Microsoft Word into a WYSIWYG editor or a
#  rich text editor. Microsoft's software is famous for injecting
#  all kinds of cruft into its HTML output. Who needs that crap?
#  Certainly not me.
#
# source://loofah//lib/loofah/scrubbers.rb#191
class Loofah::Scrubbers::Whitewash < ::Loofah::Scrubber
  # @return [Whitewash] a new instance of Whitewash
  #
  # source://loofah//lib/loofah/scrubbers.rb#192
  def initialize; end

  # source://loofah//lib/loofah/scrubbers.rb#196
  def scrub(node); end
end

# Overrides +text+ in Document and DocumentFragment classes, and mixes in +to_text+.
#
# source://loofah//lib/loofah/concerns.rb#73
module Loofah::TextBehavior
  # Returns a plain-text version of the markup contained by the document, with HTML entities
  #  encoded.
  #
  #  This method is significantly faster than #to_text, but isn't clever about whitespace around
  #  block elements.
  #
  #    Loofah.html5_document("<h1>Title</h1><div>Content</div>").text
  #    # => "TitleContent"
  #
  #  By default, the returned text will have HTML entities escaped. If you want unescaped
  #  entities, and you understand that the result is unsafe to render in a browser, then you can
  #  pass an argument as shown:
  #
  #    frag = Loofah.html5_fragment("&lt;script&gt;alert('EVIL');&lt;/script&gt;")
  #    # ok for browser:
  #    frag.text                                 # => "&lt;script&gt;alert('EVIL');&lt;/script&gt;"
  #    # decidedly not ok for browser:
  #    frag.text(:encode_special_chars => false) # => "<script>alert('EVIL');</script>"
  #
  # source://loofah//lib/loofah/concerns.rb#107
  def inner_text(options = T.unsafe(nil)); end

  # Returns a plain-text version of the markup contained by the document, with HTML entities
  #  encoded.
  #
  #  This method is significantly faster than #to_text, but isn't clever about whitespace around
  #  block elements.
  #
  #    Loofah.html5_document("<h1>Title</h1><div>Content</div>").text
  #    # => "TitleContent"
  #
  #  By default, the returned text will have HTML entities escaped. If you want unescaped
  #  entities, and you understand that the result is unsafe to render in a browser, then you can
  #  pass an argument as shown:
  #
  #    frag = Loofah.html5_fragment("&lt;script&gt;alert('EVIL');&lt;/script&gt;")
  #    # ok for browser:
  #    frag.text                                 # => "&lt;script&gt;alert('EVIL');&lt;/script&gt;"
  #    # decidedly not ok for browser:
  #    frag.text(:encode_special_chars => false) # => "<script>alert('EVIL');</script>"
  #
  # source://loofah//lib/loofah/concerns.rb#94
  def text(options = T.unsafe(nil)); end

  # Returns a plain-text version of the markup contained by the document, with HTML entities
  #  encoded.
  #
  #  This method is significantly faster than #to_text, but isn't clever about whitespace around
  #  block elements.
  #
  #    Loofah.html5_document("<h1>Title</h1><div>Content</div>").text
  #    # => "TitleContent"
  #
  #  By default, the returned text will have HTML entities escaped. If you want unescaped
  #  entities, and you understand that the result is unsafe to render in a browser, then you can
  #  pass an argument as shown:
  #
  #    frag = Loofah.html5_fragment("&lt;script&gt;alert('EVIL');&lt;/script&gt;")
  #    # ok for browser:
  #    frag.text                                 # => "&lt;script&gt;alert('EVIL');&lt;/script&gt;"
  #    # decidedly not ok for browser:
  #    frag.text(:encode_special_chars => false) # => "<script>alert('EVIL');</script>"
  #
  # source://loofah//lib/loofah/concerns.rb#108
  def to_str(options = T.unsafe(nil)); end

  # Returns a plain-text version of the markup contained by the fragment, with HTML entities
  #  encoded.
  #
  #  This method is slower than #text, but is clever about whitespace around block elements and
  #  line break elements.
  #
  #    Loofah.html5_document("<h1>Title</h1><div>Content<br>Next line</div>").to_text
  #    # => "\nTitle\n\nContent\nNext line\n"
  #
  # source://loofah//lib/loofah/concerns.rb#120
  def to_text(options = T.unsafe(nil)); end
end

# The version of Loofah you are using
#
# source://loofah//lib/loofah/version.rb#5
Loofah::VERSION = T.let(T.unsafe(nil), String)

# source://loofah//lib/loofah/xml/document.rb#4
module Loofah::XML; end

# Subclass of Nokogiri::XML::Document.
#
#  See Loofah::ScrubBehavior and Loofah::DocumentDecorator for additional methods.
#
# source://loofah//lib/loofah/xml/document.rb#10
class Loofah::XML::Document < ::Nokogiri::XML::Document
  include ::Loofah::ScrubBehavior::Node
  include ::Loofah::DocumentDecorator
end

# Subclass of Nokogiri::XML::DocumentFragment.
#
#  See Loofah::ScrubBehavior for additional methods.
#
# source://loofah//lib/loofah/xml/document_fragment.rb#10
class Loofah::XML::DocumentFragment < ::Nokogiri::XML::DocumentFragment
  class << self
    # source://loofah//lib/loofah/xml/document_fragment.rb#12
    def parse(tags); end
  end
end
