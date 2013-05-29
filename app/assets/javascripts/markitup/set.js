// -------------------------------------------------------------------
// markItUp!
// -------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// Textile tags example
// http://en.wikipedia.org/wiki/Textile_(markup_language)
// http://www.textism.com/
// -------------------------------------------------------------------
// Feel free to add more tags
// -------------------------------------------------------------------
mySettings = {
  previewParserPath: '',
  onShiftEnter: { keepDefault: false, replaceWith: '\n\n' },
  markupSet: [
    { name: 'Заголовок 3', key: '3', openWith: 'h3(!(([![Class]!]))!). ', placeHolder: 'Текст заголовка...', className: 'header_3_button' },
    { name: 'Заголовок 4', key: '4', openWith: 'h4(!(([![Class]!]))!). ', placeHolder: 'Текст заголовка...', className: 'header_4_button' },
    { separator: '-' },
    { name: 'Важно', key: 'B', closeWith: '*', openWith: '*', className: 'strong_button' },
    { name: 'Курсив', key: 'I', closeWith: '_', openWith: '_', className: 'italic_button' },
    { separator: '-' },
    { name: 'Ненумерованный список', openWith:'(!(* |!|*)!)', multiline: true, className: 'unordered_list_button' },
    { name: 'Нумерованный список', openWith:'(!(# |!|#)!)', multiline: true, className: 'ordered_list_button' },
    { separator: '-' },
    { name: 'Ссылка', openWith: '"', closeWith: '":[![Link:!:http://]!]', placeHolder: 'Текст ссылки...', className: 'link_button' },
    { name: 'Электронная почта', openWith: '"', closeWith: '":[![Link:!:mailto:]!]', placeHolder: 'Электронная почта...', className: 'email_button' },
    { name: 'Помощь', className: 'help_button' }
  ]
}
