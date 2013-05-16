require 'spec_helper'

describe Broadcastic::ModelCallbacks do

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

			let(:vendors) { {to: :vendors} }

			it "Should setup the callbacks with the correct destination" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_destroys).with(Product, vendors)

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
			let(:vendors) { {to: :vendors} }

			it "Should setup the callbacks for each event when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_creations).with(Product, vendors)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_updates).with(Product, vendors)

				class Product < ActiveRecord::Base
					broadcast :creations, :updates, to: :vendors
				end
			end

		end

	end

	context "mix'n match" do
			let(:vendors) { {to: :vendors} }
			let(:admins) { {to: :admins} }

			it "Should setup the callbacks for each event when invoked from the class definition" do
				Broadcastic::ModelCallbacks.should_receive(:broadcast_creations).with(Product, vendors)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_updates).with(Product, vendors)
				Broadcastic::ModelCallbacks.should_receive(:broadcast_destroys).with(Product, admins)

				class Product < ActiveRecord::Base
					broadcast :creations, :updates, to: :vendors
					broadcast :destroys, to: :admins
				end
			end

	end


	it "Should call broadcast event after creation" do
		undefine_product_class

		class Product < ActiveRecord::Base; end
		foo = stub
		event = stub
		# Broadcastic::ModelCallbacks.should_receive(:created).with(foo).and_return(event)
		# Broadcastic::Broadcaster.should_receive(:broadcast).with(event)

		class Product < ActiveRecord::Base
			broadcast :creations, to: :admins
			def admins
				[OpenStruct.new(id: 3)]
			end
		end
		Product.delete_all
		foo = Product.create(name: "foo")

	end

end