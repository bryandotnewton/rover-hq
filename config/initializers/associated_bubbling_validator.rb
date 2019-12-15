module ActiveRecord
  module Validations
    class AssociatedBubblingValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        puts 'aw'
        puts record
        puts attribute
        puts value
        ((value.kind_of?(Enumerable) || value.kind_of?(ActiveRecord::Relation)) ? value : [value]).each do |v|
          puts 'HUH'
          puts v.attributes
          unless v.valid?
            v.errors.full_messages.each do |msg|
              puts 'AKSDJHAKSJDHAKJSDHDKSA'
              puts msg
              record.errors.add(attribute, msg, options.merge(:value => value))
            end
          end
        end
      end
    end

    module ClassMethods
      def validates_associated_bubbling(*attr_names)
        validates_with AssociatedBubblingValidator, _merge_attributes(attr_names)
      end
    end
  end
end
