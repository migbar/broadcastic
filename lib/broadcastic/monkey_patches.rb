class String
	def to_broadcastic_channel_name
		self
	end
end

class ActiveRecord::Base
  def to_broadcastic_channel_name
    "#{self.class.to_broadcastic_channel_name}/#{id}"
  end
end