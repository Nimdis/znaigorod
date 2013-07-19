#encoding: utf-8

class MyMailer < ActionMailer::Base
  default :from => Settings['mail']['from']

  def mail_new_pending_afisha(afisha)
    @afisha = afisha
    mail(:to => Settings['mail']['to_afisha'], :subject => 'В ЗнайГород добавлена новая афиша')
  end

  def mail_new_published_afisha(afisha)
    @afisha = afisha
    mail(:to => Settings['mail']['to_afisha'], :subject => 'В ЗнайГород опубликована новая афиша')
  end

  def send_afisha_diff(version)
    @version = version
    mail(:to => Settings['mail']['to_afisha'], :subject => 'В ЗнайГород изменилась афиша')
  end
end
