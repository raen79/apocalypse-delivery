# frozen_string_literal: true

# rubocop:disable  Metrics/MethodLength, Metrics/ClassLength, Metrics/BlockLength, Metrics/AbcSize

class OrderPicklists
  class PdfGenerator
    def self.doc_title(pdf, timestamp, title)
      pdf.text title, size: 18
      pdf.text timestamp.to_s(:long), size: 12, color: '666666'
    end

    def self.order_items(pdf, items)
      table_data = [
        [
          "<color rgb='999999'>Quantity</color>",
          "<color rgb='999999'>Product</color>",
          "<color rgb='999999'>Variant</color>"
        ]
      ]
      items.each do |item|
        table_data << [item.quantity, item.product.name, item.variant.options_text]
      end
      pdf.table table_data,
                width: 540,
                row_colors: %w[F0F0F0 FFFFFF],
                cell_style: { borders: [], inline_format: true }
    end

    def self.hr(pdf)
      pdf.stroke do
        pdf.move_down 10
        pdf.stroke_color 'aaaaaa'
        pdf.dash(5, space: 2, phase: 0)
        pdf.horizontal_rule
      end
    end

    # rubocop:disable Style/IfUnlessModifier

    def self.address(pdf, order)
      address_line = order.shipping_address.address1
      if order.shipping_address.address2.present?
        address_line += ", #{order.shipping_address.address2}"
      end
      address_line += ", #{order.shipping_address.zipcode}, #{order.shipping_address.city}"
      pdf.text address_line
      pdf.text order.shipping_address.phone
    end

    # rubocop:enable Style/IfUnlessModifier

    # You are an origin store
    # - Title: What is it, for who, when - totals
    # - Generate a list of products to pack, by orders
    # - Group by destination Hub
    def self.generate_origin_lists(items_hash)
      lists = {}
      timestamp = Time.zone.now

      items_hash.each do |origin_store_id, destination_hash|
        origin_store = ::Store.find(origin_store_id)

        filename = "origin_#{origin_store.name}_#{timestamp}_packlist.pdf"
        doc =
          Prawn::Document.new do |pdf|
            doc_title pdf, timestamp, "Pack list for #{origin_store.name}"

            destination_hash.each do |destination_store_id, order_hash|
              pdf.move_down 25
              destination_store = ::Store.find(destination_store_id)
              pdf.text(
                "Deliveries to #{destination_store.name}, #{order_hash.keys.count} orders",
                size: 16
              )

              order_hash.each do |order_id, items|
                pdf.move_down 30
                order = Spree::Order.find(order_id)
                pdf.text(
                  "<b>##{order.number}</b> - #{order.shipping_address.firstname} #{
                    order.shipping_address.lastname
                  } <color rgb='999999'>(#{items.count} items)</color>",
                  size: 14, inline_format: true
                )
                order_items(pdf, items)
              end
            end
          end
        lists[filename] = doc
      end
      lists
    end

    # You are a hub store
    # - Title: what, for who, when - totals
    # - Generate a list of orders, with own products and with orders of other stores (including info)
    # - Group by destination postcodes
    def self.generate_hub_lists(items_hash)
      lists = {}
      timestamp = Time.zone.now

      items_hash.each do |hub_store_id, order_hash|
        hub_store = ::Store.find(hub_store_id)

        filename = "hub_#{hub_store.name}_#{timestamp}_packlist.pdf"
        doc =
          Prawn::Document.new do |pdf|
            doc_title pdf, timestamp, "Pack list for #{hub_store.name}"

            order_hash.each do |order_id, order_items|
              pdf.move_down 20
              order = Spree::Order.find(order_id)
              pdf.text(
                "<b>##{order.number}</b> - #{order.shipping_address.firstname} #{
                  order.shipping_address.lastname
                }",
                size: 14, inline_format: true
              )

              pdf.move_down(5)
              address(pdf, order)

              if order_items[:own_items].any?
                pdf.move_down 10
                order_items(pdf, order_items[:own_items])
              end

              if order_items[:proxy_items].any?
                order_items[:proxy_items].each do |origin_store_id, items|
                  next unless items.any?

                  pdf.move_down(10)
                  pdf.indent(20) do
                    origin_store = ::Store.find(origin_store_id)
                    pdf.text(
                      "+ <b>#{items.size}</b> items from #{origin_store.name}:",
                      inline_format: true
                    )
                    sub_items =
                      items.map do |item|
                        "#{item.quantity} x (#{item.product.name} #{item.variant.options_text})"
                      end
                    pdf.text sub_items.join(', ')
                  end
                end
              end
              hr(pdf)
            end
          end
        lists[filename] = doc
      end

      lists
    end

    # You are a courier
    # - Title: What, where, when - totals
    # - List of sources stores and items
    # - Group by postocdes
    def self.generate_delivery_lists(items_hash)
      lists = {}
      timestamp = Time.zone.now
      items_hash.each do |hub_store_id, zipcodes_hash|
        hub_store = ::Store.find(hub_store_id)

        filename = "deliveries_#{hub_store.name}_#{timestamp}.pdf"
        doc =
          Prawn::Document.new do |pdf|
            doc_title pdf, timestamp, "Delivery list for #{hub_store.name}"

            zipcodes_hash.each do |zipcode, order_hash|
              pdf.move_down 15
              pdf.text "Zipcode #{zipcode}", size: 16

              order_hash.each do |order_id, origin_hash|
                pdf.move_down 15
                order = Spree::Order.find(order_id)
                pdf.text(
                  "<b>##{order.number}</b> - #{order.shipping_address.firstname} #{
                    order.shipping_address.lastname
                  }",
                  size: 12, inline_format: true
                )

                pdf.move_down(5)
                address(pdf, order)
                pdf.move_down(8)

                origin_hash.each do |_origin_store_id, details|
                  item_count = details[:items].sum(&:quantity)
                  pdf.text(
                    "<b>#{item_count}</b> x items from #{details[:origin_store].name}",
                    inline_format: true
                  )
                end

                hr(pdf)
              end
            end
          end
        lists[filename] = doc
      end
      lists
    end
  end
end

# rubocop:enable  Metrics/MethodLength, Metrics/ClassLength, Metrics/BlockLength, Metrics/AbcSize
