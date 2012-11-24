module CivicCommonsDriver
  module Pages
    class Admin
      class Issues
        SHORT_NAME = :admin_issues
        include Page
        add_link_for(:edit, "Edit", :admin_issues_edit)

        class Add
          SHORT_NAME = :admin_add_issue
          include Page
          include Database

          has_field(:name, 'Name')
          has_wysiwyg_editor_field(:summary, 'issue_summary')
          has_field(:zip_code, 'Zip code')
          has_button(:create_issue, 'Create Issue', :admin_issues)
          has_button(:create_issue_while_in_invalid_state, 'Create Issue', :admin_add_issue)

          def attach_image file_name
            attach_file 'issue[image]', File.join(attachments_path, file_name)
          end
          def select_topic topic
            check topic
          end
          def has_reminder_to_add_topics?
            within '#error_explanation' do
              has_content? "Please select at least one Topic"
            end
          end
          def fill_in_issue_with details
            details = defaults.merge details

            fill_in_name_with details[:name]
            details[:topics].each do | topic |
              select_topic topic.name
            end
            attach_image details[:image]
            fill_in_summary_with details[:summary]
            fill_in_zip_code_with details[:postal_code]
          end
          def defaults
            {
              :name => "WOOwoop",
              :summary => "SUMMMED",
              :topics => [database.first_topic],
              :image => "imageAttachment.png",
              :postal_code => "48867"
            }
          end
        end

        class Edit
          SHORT_NAME = :admin_issues_edit
          include Page
          has_field(:page_title, "Page Title")
          has_field(:meta_description, "Page Description")
          has_field(:meta_tags, "Page Meta Tags")
          has_button(:update_issue, "Update Issue")
        end
      end
    end 
  end 
end
