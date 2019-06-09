Deface::Override.new(virtual_path: 'spree/admin/products/_form',
  name: 'add_store_to_products',
  insert_after: "[data-hook='admin_product_form_tax_category']",
  text: "
    <div data-hook='admin_product_form_store_id'>
      <%= f.field_container :store_id, class: ['form-group'] do %>
        <%= f.label :store_id, Spree.t(:store_id) %>
        <%= f.collection_select(:store_id, Spree::Store.all, :id, :name, { include_blank: Spree.t('match_choices.none') }, { class: 'select2' }) %>
        <%= f.error_message_on :store_id %>
      <% end %>
    </div>
  ")
