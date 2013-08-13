#encoding: utf-8

class MyMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def mail_new_pending_affiche(affiche)
    @affiche = affiche
    mail(:to => Settings['mail']['to_affiche'], :subject => 'В ЗнайГород добавлена новая афиша')
  end

  def mail_new_published_affiche(affiche)
    @affiche = affiche
    mail(:to => Settings['mail']['to_affiche'], :subject => 'В ЗнайГород опубликована новая афиша')
  end

  def send_affiche_diff(version)
    @version = version
    mail(:to => Settings['mail']['to_affiche'], :subject => 'В ЗнайГород изменилась афиша')
  end

  def not_enough_ticket_copies(paymentable)
    mail(:to => Settings['mail']['to_affiche'], :subject => 'Проблема с билетами') do |format|
      format.text do
        render :text => "#{paymentable.description}. Похоже, что недостаточно билетов"
      end
    end
  end
end
