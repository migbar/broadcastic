require 'spec_helper'

class Product < ActiveRecord::Base; end

describe Broadcastic::Broadcast do

	context "with a single event" do
		context "without options" do
			let(:no_options) { {} }

			it "Should setup the creation callbacks when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_creations).with(Product, no_options)

				class Product < ActiveRecord::Base
					broadcast :creations
				end
			end

			it "Should setup the update callbacks when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_updates).with(Product, no_options)

				class Product < ActiveRecord::Base
					broadcast :updates
				end
			end

			it "Should setup the destroy callbacks when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_destroys).with(Product, no_options)

				class Product < ActiveRecord::Base
					broadcast :destroys
				end
			end

			it "Should setup all callbacks when :changes are invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_creations).with(Product, no_options)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_updates).with(Product, no_options)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_destroys).with(Product, no_options)

				class Product < ActiveRecord::Base
					broadcast :changes
				end
			end
		end

		context "with :to option"	do

			let(:options) { {to: :vendors} }

			it "Should setup the callbacks with the correct destination" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_destroys).with(Product, options)

				class Product < ActiveRecord::Base
					broadcast :destroys, to: :vendors
				end
			end

		end
	end

	context "with multiple events" do
		context "without options" do
			let(:no_options) { {} }

			it "Should setup the callbacks for each event when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_creations).with(Product, no_options)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_updates).with(Product, no_options)

				class Product < ActiveRecord::Base
					broadcast :creations, :updates
				end
			end

		end

		context "with :to option" do
			let(:options) { {to: :vendors} }

			it "Should setup the callbacks for each event when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_creations).with(Product, options)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_updates).with(Product, options)

				class Product < ActiveRecord::Base
					broadcast :creations, :updates, to: :vendors
				end
			end

		end

	end

	context "mix'n match" do
			let(:options) { {to: :vendors} }
			let(:admins) { {to: :admins} }

			it "Should setup the callbacks for each event when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_creations).with(Product, options)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_updates).with(Product, options)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_destroys).with(Product, admins)

				class Product < ActiveRecord::Base
					broadcast :creations, :updates, to: :vendors
					broadcast :destroys, to: :admins
				end
			end

	end

	context "with an invalid event" do
		it "Should raise an exception" do
			expect  {
				class Product < ActiveRecord::Base
					broadcast :some_non_existing_callback
				end
			}.to raise_error(Broadcastic::InvalidCallbackName)
		end
	end

	context "with an invalid recipient" do

		it "Should raise an exception about the recipient method being invalid" do

			undefine_product_class

			expect  {
				class Product < ActiveRecord::Base
					broadcast :creations, to: :some_recipient
				end
				p = Product.create(name: "foo")
			}.to raise_error(NoMethodError, /undefined method `some_recipient'/)
		end
	end

	context "with an valid recipient" do

		it "Should not raise an exception about the recipient method being invalid" do

		  undefine_product_class

			expect  {
				class Product < ActiveRecord::Base
					broadcast :creations, to: :vendors

					def vendors
						["abc", "cef"]
					end
				end
				p = Product.create(name: "foo")
			}.to_not raise_error(NoMethodError, /undefined method `some_recipient'/)
		end
	end

end
