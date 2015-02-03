module PrivateLabels
  module Admin

    class PrivateLabelPeopleController < BaseController

      load_and_authorize_resource

      def index
      end

      ##
      # Switch the admin value on the PrivateLabelPerson record to
      # either true or false.
      def toggle_admin
        @private_label_person.admin = !@private_label_person.admin
        if @private_label_person.save
          redirect_to private_labels_admin_private_label_people_path, notice: 'Status updated successfully!'
        else
          redirect_to private_labels_admin_private_label_people_path, alert: 'There was an error updating the status.'
        end
      end

      def destroy
        @private_label_person.destroy
        if @private_label_person.destroyed?
          redirect_to private_labels_admin_private_label_people_path, notice: "The person has been removed from #{Swayze.current_private_label.name}"
        else
          redirect_to private_labels_admin_private_label_people_path, alert: "There was an error removing the person from #{Swayze.current_private_label.name}"
        end
      end

    end

  end   # Admin module
end     # PrivateLabels module
