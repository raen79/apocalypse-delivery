# frozen_string_literal: true

class PickListMailer < ApplicationMailer
  DESTINATION = 'cody.n.toth@gmail.com'

  def origin(lists)
    attach_lists(lists)
    mail(to: DESTINATION, subject: 'Origin store packing lists')
  end

  def hub(lists)
    attach_lists(lists)
    mail(to: DESTINATION, subject: 'Hub store packing lists')
  end

  def delivery(lists)
    attach_lists(lists)
    mail(to: DESTINATION, subject: 'Delivery lists')
  end

  private

  def attach_lists(lists)
    lists.each do |filename, pdf|
      attachments[filename] = { mime_type: 'application/pdf', content: pdf.render }
    end
  end
end
