# encoding: utf-8
module CollectionSpecs
  def self.array_with_usascii_and_7bit_utf8_strings(subject_class)
    subject_class.new [
      'foo'.force_encoding('US-ASCII'),
      'bar'
    ]
  end

  def self.array_with_usascii_and_utf8_strings(subject_class)
    subject_class.new [
      'foo'.force_encoding('US-ASCII'),
      'báz'
    ]
  end

  def self.array_with_7bit_utf8_and_usascii_strings(subject_class)
    subject_class.new [
      'bar',
      'foo'.force_encoding('US-ASCII')
    ]
  end

  def self.array_with_utf8_and_usascii_strings(subject_class)
    subject_class.new [
      'báz',
      'bar',
      'foo'.force_encoding('US-ASCII')
    ]
  end

  def self.array_with_usascii_and_utf8_strings(subject_class)
    subject_class.new [
      'foo'.force_encoding('US-ASCII'),
      'bar',
      'báz'
    ]
  end

  def self.array_with_utf8_and_7bit_binary_strings(subject_class)
    subject_class.new [
      'bar',
      'báz',
      'foo'.force_encoding('BINARY')
    ]
  end

  def self.array_with_utf8_and_binary_strings(subject_class)
    subject_class.new [
      'bar',
      'báz',
      [255].pack('C').force_encoding('BINARY')
    ]
  end

  def self.array_with_usascii_and_7bit_binary_strings(subject_class)
    subject_class.new [
      'bar'.force_encoding('US-ASCII'),
      'foo'.force_encoding('BINARY')
    ]
  end

  def self.array_with_usascii_and_binary_strings(subject_class)
    subject_class.new [
      'bar'.force_encoding('US-ASCII'),
      [255].pack('C').force_encoding('BINARY')
    ]
  end
end
