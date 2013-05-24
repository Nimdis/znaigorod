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
  previewParserPath:  '', // path to your Textile parser
  onShiftEnter:    {keepDefault:false, replaceWith:'\n\n'},
  markupSet: [
    {name:'Заголовок 3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
    {name:'Заголовок 4', key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
    {separator:'---------------' },
    {name:'Жирно', key:'B', closeWith:'*', openWith:'*'},
    {name:'Курсив', key:'I', closeWith:'_', openWith:'_'},
    {separator:'---------------' },
    {name:'Ненумерованный список', openWith:'(!(* |!|*)!)'},
    {name:'Нумерованный список', openWith:'(!(# |!|#)!)'},
    {separator:'---------------' },
    {name:'Ссылка', openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Your text to link here...' },
  ]
}
