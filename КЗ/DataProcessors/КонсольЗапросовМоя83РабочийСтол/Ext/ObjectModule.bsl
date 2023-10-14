﻿


Функция ОтладкаЗапросаИзКонфигуратора(ЗапросИзКонфигуратора) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку(); 
	
	ДанныеПоЗапросу = Новый Структура();
	ДанныеПоЗапросу.Вставить("Параметры", ЗапросИзКонфигуратора.Параметры);
	ДанныеПоЗапросу.Вставить("Текст", ЗапросИзКонфигуратора.Текст);
	
	ДанныеПоЗапросу.Вставить("МенеджерВТ_РезультатыЗапроса", Новый Массив);    
	Если ЗапросИзКонфигуратора.МенеджерВременныхТаблиц <> Неопределено тогда
		Для каждого ВременнаяТаблицаЗапроса из ЗапросИзКонфигуратора.МенеджерВременныхТаблиц.Таблицы цикл
			РезультатЗапроса = ВременнаяТаблицаЗапроса.ПолучитьДанные(); 
			ТЗ = РезультатЗапроса.Выгрузить();
			ДанныеПоЗапросу.МенеджерВТ_РезультатыЗапроса.Добавить(Новый Структура("ТЗ,ИмяТаблицыВТ",ТЗ,ВременнаяТаблицаЗапроса.ПолноеИмя));
		КонецЦикла;
	КонецЕсли;
	
	
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, ДанныеПоЗапросу, НазначениеТипаXML.Явное); 
	ТекстXML = ЗаписьXML.Закрыть();
	
	Возврат ТекстXML;
	
КонецФункции

//Объект.ПутьКФормам = РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя() + ".Форма";
ЭтотОбъект.ПутьКФормам = ЭтотОбъект.Метаданные().ПолноеИмя() + ".Форма";        








