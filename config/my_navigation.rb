# encoding: utf-8

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :my, 'Личный кабинет', my_root_path, highlights_on: /^\/my[\/]?$|^\/my\/afisha[\/]?$/ do |my_item|
      my_item.item :new_afisha, 'Создание мероприятия', new_my_afisha_path
      my_item.item :afisha, @afisha.title || 'Нет названия', my_afisha_path(@afisha) do |afisha_item|
        afisha_item.item :first_step, 'Описание', edit_step_my_afisha_path(@afisha, :first)

        afisha_item.item :second_step, 'Постер', edit_step_my_afisha_path(@afisha, :second)

        afisha_item.item :fourth_step, 'Фотографии', edit_step_my_afisha_path(@afisha, :fourth)

        afisha_item.item :fifth_step, 'Видео', edit_step_my_afisha_path(@afisha, :fifth)

        afisha_item.item :fourth_step, 'Файлы', edit_step_my_afisha_path(@afisha, :sixth)

        afisha_item.item :showings, 'Расписание', new_my_afisha_showing_path(@afisha)

        afisha_item.item :showings, 'Расписание', edit_my_afisha_showing_path(@afisha, @showing) if @showing && @showing.persisted?
      end if @afisha && @afisha.persisted?
    end
    primary.dom_class = 'breadcrumbs'
  end
end
