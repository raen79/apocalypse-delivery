# frozen_string_literal: true

class OrderPicklists
  def self.process_outstanding!
    outstanding_orders = Spree::Order.where(state: 'complete').not_picked.all

    # Generate lists
    lists = ListGenerator.generate_lists(outstanding_orders)

    # Generate and send PDFs
    process_lists(lists)

    # Mark orders `picked`
    orders.each(&:pick!)

    # TODO: Mark orders `shipped` ?
  end

  def self.process_lists(lists)
    origin_pdfs = OrderListPdfGenerator.generate_origin_lists(lists[:origin_store_orders])
    PickListMailer.origin(origin_pdfs)

    hub_pdfs = OrderListPdfGenerator.generate_hub_lists(lists[:hub_store_orders])
    PickListMailer.hub(hub_pdfs)

    delivery_pdfs = OrderListPdfGenerator.generate_delivery_lists(lists[:delivery_orders])
    PickListMailer.delivery(delivery_pdfs)
  end
end
