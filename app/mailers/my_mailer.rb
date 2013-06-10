#encoding: utf-8

class MyMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def mail_new_pending_affiche(affiche)
    @affiche = affiche
    mail(:to => Settings['mail']['to_affiche'], :subject => 'В ЗнайГород добавлена новая афиша')
  end
end
