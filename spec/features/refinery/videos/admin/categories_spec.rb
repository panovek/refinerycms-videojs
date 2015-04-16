# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Videos" do
    describe "Admin" do
      describe "categories" do
        refinery_login_with :refinery

        describe "categories list" do
          before do
            FactoryGirl.create(:category, :name => "UniqueTitleOne")
            FactoryGirl.create(:category, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.videos_admin_categories_path
            expect(page).to have_content("UniqueTitleOne")
            expect(page).to have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.videos_admin_categories_path

            click_link "Add New Category"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              expect { click_button "Save" }.to change(Refinery::Videos::Category, :count).from(0).to(1)

              expect(page).to have_content("'This is a test of the first string field' was successfully added.")
            end
          end

          context "invalid data" do
            it "should fail" do
              expect { click_button "Save" }.not_to change(Refinery::Videos::Category, :count)

              expect(page).to have_content("Name can't be blank")
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:category, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.videos_admin_categories_path

              click_link "Add New Category"

              fill_in "Name", :with => "UniqueTitle"
              expect { click_button "Save" }.not_to change(Refinery::Videos::Category, :count)

              expect(page).to have_content("There were problems")
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:category, :name => "A name") }

          it "should succeed" do
            visit refinery.videos_admin_categories_path

            within ".actions" do
              click_link "Edit this category"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            expect(page).to have_content("'A different name' was successfully updated.")
            expect(page).not_to have_content("A name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:category, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.videos_admin_categories_path

            click_link "Remove this category forever"

            expect(page).to have_content("'UniqueTitleOne' was successfully removed.")
            expect(Refinery::Videos::Category.count).to eq(0)
          end
        end

      end
    end
  end
end
