#encoding: utf-8

class CopyPaymentMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def notification(email, copy_payment)
    @copy_payment = copy_payment

    mail(:to => email, :subject => 'На сайте znaigorod.ru проданы билеты')
  end

  def report(email, ticket)
    @ticket = ticket

    mail(:to => email, :subject => 'На сайте znaigorod.ru завершилась продажа билетов')
  end
end
