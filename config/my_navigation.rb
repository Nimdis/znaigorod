# encoding: utf-8

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :my, 'Мои афиши', my_root_path do |my_item|
      my_item.item :new_affiche, 'Создание мероприятия', new_my_affiche_path
      my_item.item :archive, 'Архив', archive_my_affiches_path
      my_item.item :affiche, @affiche.title || 'Нет названия', my_affiche_path(@affiche) do |affiche_item|
        affiche_item.item :first_step, 'Описание', edit_step_my_affiche_path(@affiche, :first)

        affiche_item.item :second_step, 'Постер', edit_step_my_affiche_path(@affiche, :second)

        affiche_item.item :fourth_step, 'Фотографии', edit_step_my_affiche_path(@affiche, :fourth)

        affiche_item.item :fifth_step, 'Видео', edit_step_my_affiche_path(@affiche, :fifth)

        affiche_item.item :fourth_step, 'Файлы', edit_step_my_affiche_path(@affiche, :sixth)

        affiche_item.item :showings, 'Расписание', new_my_affiche_showing_path(@affiche)

        affiche_item.item :showings, 'Расписание', edit_my_affiche_showing_path(@affiche, @showing) if @showing && @showing.persisted?
      end if @affiche && @affiche.persisted?
    end
    primary.dom_class = 'breadcrumbs'
  end
end
