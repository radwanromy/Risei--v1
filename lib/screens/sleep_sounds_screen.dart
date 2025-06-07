import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import '../theme_colors.dart';

// --- Localization Section ---

const Map<String, String> languageNames = {
  'en': 'English',
  'ja': '日本語',
  'bn': 'বাংলা',
  'es': 'Español',
  'fr': 'Français',
  'ar': 'العربية',
  'zh': '中文',
};

const Map<String, Map<String, String>> localizedStrings = {
  // Bottom nav and common labels
  'sounds': {
    'en': 'Sounds',
    'ja': 'サウンド',
    'bn': 'সাউন্ড',
    'es': 'Sonidos',
    'fr': 'Sons',
    'ar': 'الأصوات',
    'zh': '声音',
  },
  'custom': {
    'en': 'Custom',
    'ja': 'カスタム',
    'bn': 'কাস্টম',
    'es': 'Personalizado',
    'fr': 'Personnalisé',
    'ar': 'مخصص',
    'zh': '自定义',
  },
  'settings': {
    'en': 'Settings',
    'ja': '設定',
    'bn': 'সেটিংস',
    'es': 'Configuración',
    'fr': 'Paramètres',
    'ar': 'الإعدادات',
    'zh': '设置',
  },
  'sleep_sounds': {
    'en': 'Sleep Sounds',
    'ja': '睡眠サウンド',
    'bn': 'ঘুমের সাউন্ড',
    'es': 'Sonidos para dormir',
    'fr': 'Sons de sommeil',
    'ar': 'أصوات النوم',
    'zh': '助眠音效',
  },
  'go_to_custom_mix': {
    'en': 'Go to Custom Mix',
    'ja': 'カスタムミックスへ',
    'bn': 'কাস্টম মিক্সে যান',
    'es': 'Ir a Mezcla personalizada',
    'fr': 'Aller au mix personnalisé',
    'ar': 'اذهب إلى المزيج المخصص',
    'zh': '前往自定义混音',
  },
  'custom_mix': {
    'en': 'Custom Mix',
    'ja': 'カスタムミックス',
    'bn': 'কাস্টম মিক্স',
    'es': 'Mezcla personalizada',
    'fr': 'Mix personnalisé',
    'ar': 'مزيج مخصص',
    'zh': '自定义混音',
  },
  'no_sounds_mix': {
    'en': 'No sounds in your mix.\nAdd from main tab!',
    'ja': 'ミックスにサウンドがありません。\nメインタブから追加してください！',
    'bn': 'আপনার মিক্সে কোনো সাউন্ড নেই।\nমূল ট্যাব থেকে যোগ করুন!',
    'es': 'No hay sonidos en tu mezcla.\n¡Agrega desde la pestaña principal!',
    'fr': 'Aucun son dans votre mix.\nAjoutez-en depuis l\'onglet principal !',
    'ar': 'لا أصوات في المزيج الخاص بك.\nأضف من علامة التبويب الرئيسية!',
    'zh': '您的混音中没有声音。\n请从主标签页添加！',
  },
  'set_sleep_timer': {
    'en': 'Set Sleep Timer',
    'ja': 'スリープタイマー設定',
    'bn': 'স্লিপ টাইমার সেট করুন',
    'es': 'Configurar temporizador',
    'fr': 'Définir minuterie',
    'ar': 'ضبط مؤقت النوم',
    'zh': '设置睡眠定时器',
  },
  'custom_min': {
    'en': 'Custom minutes',
    'ja': 'カスタム分数',
    'bn': 'কাস্টম মিনিট',
    'es': 'Minutos personalizados',
    'fr': 'Minutes personnalisées',
    'ar': 'دقائق مخصصة',
    'zh': '自定义分钟',
  },
  'set': {
    'en': 'Set',
    'ja': '設定',
    'bn': 'সেট',
    'es': 'Establecer',
    'fr': 'Définir',
    'ar': 'ضبط',
    'zh': '设置',
  },
  'cancel': {
    'en': 'Cancel',
    'ja': 'キャンセル',
    'bn': 'বাতিল',
    'es': 'Cancelar',
    'fr': 'Annuler',
    'ar': 'إلغاء',
    'zh': '取消',
  },
  'stop_all_sounds': {
    'en': 'Stop All Sounds',
    'ja': 'すべてのサウンドを停止',
    'bn': 'সব সাউন্ড বন্ধ করুন',
    'es': 'Detener todos los sonidos',
    'fr': 'Arrêter tous les sons',
    'ar': 'إيقاف جميع الأصوات',
    'zh': '停止所有声音',
  },
  'app_version': {
    'en': 'Sleep Sounds App v1.0',
    'ja': 'スリープサウンドアプリ v1.0',
    'bn': 'স্লিপ সাউন্ডস অ্যাপ v1.0',
    'es': 'App de Sonidos para Dormir v1.0',
    'fr': 'Application Sleep Sounds v1.0',
    'ar': 'تطبيق أصوات النوم v1.0',
    'zh': '助眠音效App v1.0',
  },

  // Sound category titles
  'rain_thunders': {
    'en': 'Rain & Thunders',
    'ja': '雨と雷',
    'bn': 'বৃষ্টি ও বজ্রপাত',
    'es': 'Lluvia y truenos',
    'fr': 'Pluie & Tonnerre',
    'ar': 'المطر والرعد',
    'zh': '雨与雷',
  },
  'nature': {
    'en': 'Nature',
    'ja': '自然',
    'bn': 'প্রকৃতি',
    'es': 'Naturaleza',
    'fr': 'Nature',
    'ar': 'الطبيعة',
    'zh': '自然',
  },
  'animal': {
    'en': 'Animal',
    'ja': '動物',
    'bn': 'প্রাণী',
    'es': 'Animales',
    'fr': 'Animaux',
    'ar': 'الحيوانات',
    'zh': '动物',
  },
  'transport': {
    'en': 'Transport',
    'ja': '乗り物',
    'bn': 'পরিবহন',
    'es': 'Transporte',
    'fr': 'Transport',
    'ar': 'النقل',
    'zh': '交通',
  },
  'city_instrument': {
    'en': 'City & Instrument',
    'ja': '都市と楽器',
    'bn': 'শহর ও যন্ত্র',
    'es': 'Ciudad e instrumento',
    'fr': 'Ville & Instrument',
    'ar': 'المدينة والآلات',
    'zh': '城市与乐器',
  },
  'white_noise': {
    'en': 'White Noise',
    'ja': 'ホワイトノイズ',
    'bn': 'হোয়াইট নয়েজ',
    'es': 'Ruido blanco',
    'fr': 'Bruit blanc',
    'ar': 'الضوضاء البيضاء',
    'zh': '白噪音',
  },
  'meditation': {
    'en': 'Meditation',
    'ja': '瞑想',
    'bn': 'ধ্যান',
    'es': 'Meditación',
    'fr': 'Méditation',
    'ar': 'تأمل',
    'zh': '冥想',
  },

  // Sound names
  'light_rain': {
    'en': 'Light Rain',
    'ja': '小雨',
    'bn': 'হালকা বৃষ্টি',
    'es': 'Lluvia ligera',
    'fr': 'Pluie légère',
    'ar': 'مطر خفيف',
    'zh': '小雨',
  },
  'heavy_rain': {
    'en': 'Heavy Rain',
    'ja': '大雨',
    'bn': 'ভারী বৃষ্টি',
    'es': 'Lluvia fuerte',
    'fr': 'Pluie forte',
    'ar': 'مطر غزير',
    'zh': '大雨',
  },
  'thunder': {
    'en': 'Thunder',
    'ja': '雷',
    'bn': 'বজ্রধ্বনি',
    'es': 'Trueno',
    'fr': 'Tonnerre',
    'ar': 'رعد',
    'zh': '雷声',
  },
  'rain_on_umbrella': {
    'en': 'Rain on Umbrella',
    'ja': '傘の上の雨',
    'bn': 'ছাতায় বৃষ্টি',
    'es': 'Lluvia en paraguas',
    'fr': 'Pluie sur parapluie',
    'ar': 'مطر على المظلة',
    'zh': '伞上的雨',
  },
  'rain_on_window': {
    'en': 'Rain on Window',
    'ja': '窓の雨',
    'bn': 'জানালায় বৃষ্টি',
    'es': 'Lluvia en ventana',
    'fr': 'Pluie sur fenêtre',
    'ar': 'مطر على النافذة',
    'zh': '窗上的雨',
  },
  'snow': {
    'en': 'Snow',
    'ja': '雪',
    'bn': 'তুষার',
    'es': 'Nieve',
    'fr': 'Neige',
    'ar': 'ثلج',
    'zh': '雪',
  },
  'rain_on_roof': {
    'en': 'Rain on Roof',
    'ja': '屋根の雨',
    'bn': 'ছাদে বৃষ্টি',
    'es': 'Lluvia en el techo',
    'fr': 'Pluie sur le toit',
    'ar': 'مطر على السطح',
    'zh': '屋顶上的雨',
  },
  'rain_on_tent': {
    'en': 'Rain on Tent',
    'ja': 'テントの雨',
    'bn': 'তাঁবুতে বৃষ্টি',
    'es': 'Lluvia en la tienda',
    'fr': 'Pluie sur la tente',
    'ar': 'مطر على الخيمة',
    'zh': '帐篷上的雨',
  },
  'rain_on_puddle': {
    'en': 'Rain on Puddle',
    'ja': '水たまりの雨',
    'bn': 'জলকাদায় বৃষ্টি',
    'es': 'Lluvia en el charco',
    'fr': 'Pluie sur flaque',
    'ar': 'مطر على البركة',
    'zh': '水洼上的雨',
  },
  'ocean': {
    'en': 'Ocean',
    'ja': '海',
    'bn': 'সমুদ্র',
    'es': 'Océano',
    'fr': 'Océan',
    'ar': 'المحيط',
    'zh': '海洋',
  },
  'lake': {
    'en': 'Lake',
    'ja': '湖',
    'bn': 'হ্রদ',
    'es': 'Lago',
    'fr': 'Lac',
    'ar': 'بحيرة',
    'zh': '湖泊',
  },
  'creek': {
    'en': 'Creek',
    'ja': '小川',
    'bn': 'ছোট নদী',
    'es': 'Arroyo',
    'fr': 'Ruisseau',
    'ar': 'خور',
    'zh': '小溪',
  },
  'forest': {
    'en': 'Forest',
    'ja': '森',
    'bn': 'বন',
    'es': 'Bosque',
    'fr': 'Forêt',
    'ar': 'غابة',
    'zh': '森林',
  },
  'wind_leaves': {
    'en': 'Wind Leaves',
    'ja': '風と葉',
    'bn': 'পাতায় হাওয়া',
    'es': 'Viento en hojas',
    'fr': 'Vent dans les feuilles',
    'ar': 'الرياح والأوراق',
    'zh': '风吹树叶',
  },
  'wind': {
    'en': 'Wind',
    'ja': '風',
    'bn': 'হাওয়া',
    'es': 'Viento',
    'fr': 'Vent',
    'ar': 'رياح',
    'zh': '风',
  },
  'waterfall': {
    'en': 'Waterfall',
    'ja': '滝',
    'bn': 'ঝর্ণা',
    'es': 'Cascada',
    'fr': 'Cascade',
    'ar': 'شلال',
    'zh': '瀑布',
  },
  'drip': {
    'en': 'Drip',
    'ja': 'しずく',
    'bn': 'টিপটিপ',
    'es': 'Goteo',
    'fr': 'Goutte',
    'ar': 'تقطر',
    'zh': '滴水',
  },
  'underwater': {
    'en': 'Underwater',
    'ja': '水中',
    'bn': 'জলের নিচে',
    'es': 'Bajo el agua',
    'fr': 'Sous l\'eau',
    'ar': 'تحت الماء',
    'zh': '水下',
  },
  'farm': {
    'en': 'Farm',
    'ja': '農場',
    'bn': 'ফার্ম',
    'es': 'Granja',
    'fr': 'Ferme',
    'ar': 'مزرعة',
    'zh': '农场',
  },
  'grassland': {
    'en': 'Grassland',
    'ja': '草原',
    'bn': 'ঘাসের মাঠ',
    'es': 'Pradera',
    'fr': 'Prairie',
    'ar': 'مرج',
    'zh': '草原',
  },
  'fire': {
    'en': 'Fire',
    'ja': '火',
    'bn': 'আগুন',
    'es': 'Fuego',
    'fr': 'Feu',
    'ar': 'نار',
    'zh': '火',
  },
  'bird': {
    'en': 'Bird',
    'ja': '鳥',
    'bn': 'পাখি',
    'es': 'Pájaro',
    'fr': 'Oiseau',
    'ar': 'طائر',
    'zh': '鸟',
  },
  'bird2': {
    'en': 'Bird 2',
    'ja': '鳥2',
    'bn': 'পাখি ২',
    'es': 'Pájaro 2',
    'fr': 'Oiseau 2',
    'ar': 'طائر 2',
    'zh': '鸟2',
  },
  'seagull': {
    'en': 'Seagull',
    'ja': 'カモメ',
    'bn': 'সীগাল',
    'es': 'Gaviota',
    'fr': 'Mouette',
    'ar': 'نورَس',
    'zh': '海鸥',
  },
  'frog': {
    'en': 'Frog',
    'ja': 'カエル',
    'bn': 'ব্যাঙ',
    'es': 'Rana',
    'fr': 'Grenouille',
    'ar': 'ضفدع',
    'zh': '青蛙',
  },
  'frog2': {
    'en': 'Frog 2',
    'ja': 'カエル2',
    'bn': 'ব্যাঙ ২',
    'es': 'Rana 2',
    'fr': 'Grenouille 2',
    'ar': 'ضفدع 2',
    'zh': '青蛙2',
  },
  'cricket': {
    'en': 'Cricket',
    'ja': 'コオロギ',
    'bn': 'ঝিঁঝিঁ পোকা',
    'es': 'Grillo',
    'fr': 'Grillon',
    'ar': 'صرصور الليل',
    'zh': '蟋蟀',
  },
  'cicada': {
    'en': 'Cicada',
    'ja': 'セミ',
    'bn': 'ঝিঁঝিঁ',
    'es': 'Cigarra',
    'fr': 'Cigale',
    'ar': 'زيز',
    'zh': '蝉',
  },
  'wolf': {
    'en': 'Wolf',
    'ja': 'オオカミ',
    'bn': 'নেকড়ে',
    'es': 'Lobo',
    'fr': 'Loup',
    'ar': 'ذئب',
    'zh': '狼',
  },
  'loon': {
    'en': 'Loon',
    'ja': 'アビ',
    'bn': 'লুন',
    'es': 'Colimbo',
    'fr': 'Plongeon',
    'ar': 'غواص',
    'zh': '潜鸟',
  },
  'cat_purring': {
    'en': 'Cat Purring',
    'ja': '猫のゴロゴロ',
    'bn': 'বিড়ালের ঘরঘর',
    'es': 'Ronroneo de gato',
    'fr': 'Ronronnement de chat',
    'ar': 'خرخرة القط',
    'zh': '猫呼噜',
  },
  'whale': {
    'en': 'Whale',
    'ja': 'クジラ',
    'bn': 'তিমি',
    'es': 'Ballena',
    'fr': 'Baleine',
    'ar': 'حوت',
    'zh': '鲸鱼',
  },
  'owl': {
    'en': 'Owl',
    'ja': 'フクロウ',
    'bn': 'পেঁচা',
    'es': 'Búho',
    'fr': 'Hibou',
    'ar': 'بومة',
    'zh': '猫头鹰',
  },
  'train': {
    'en': 'Train',
    'ja': '電車',
    'bn': 'ট্রেন',
    'es': 'Tren',
    'fr': 'Train',
    'ar': 'قطار',
    'zh': '火车',
  },
  'car': {
    'en': 'Car',
    'ja': '車',
    'bn': 'গাড়ি',
    'es': 'Coche',
    'fr': 'Voiture',
    'ar': 'سيارة',
    'zh': '汽车',
  },
  'airplane': {
    'en': 'Airplane',
    'ja': '飛行機',
    'bn': 'বিমান',
    'es': 'Avión',
    'fr': 'Avion',
    'ar': 'طائرة',
    'zh': '飞机',
  },
  'construction_site': {
    'en': 'Construction Site',
    'ja': '建設現場',
    'bn': 'নির্মাণ সাইট',
    'es': 'Sitio de construcción',
    'fr': 'Chantier',
    'ar': 'موقع بناء',
    'zh': '建筑工地',
  },
  'lullaby': {
    'en': 'Lullaby',
    'ja': '子守唄',
    'bn': 'লালাবাই',
    'es': 'Canción de cuna',
    'fr': 'Berceuse',
    'ar': 'تهويدة',
    'zh': '摇篮曲',
  },
  'dryer': {
    'en': 'Dryer',
    'ja': '乾燥機',
    'bn': 'ড্রায়ার',
    'es': 'Secadora',
    'fr': 'Sèche-linge',
    'ar': 'مجفف',
    'zh': '烘干机',
  },
  'hair_dryer': {
    'en': 'Hair Dryer',
    'ja': 'ヘアドライヤー',
    'bn': 'হেয়ার ড্রায়ার',
    'es': 'Secador de pelo',
    'fr': 'Sèche-cheveux',
    'ar': 'مجفف شعر',
    'zh': '吹风机',
  },
  'vacuum_cleaner': {
    'en': 'Vacuum Cleaner',
    'ja': '掃除機',
    'bn': 'ভ্যাকুয়াম ক্লিনার',
    'es': 'Aspiradora',
    'fr': 'Aspirateur',
    'ar': 'مكنسة كهربائية',
    'zh': '吸尘器',
  },
  'fan': {
    'en': 'Fan',
    'ja': '扇風機',
    'bn': 'ফ্যান',
    'es': 'Ventilador',
    'fr': 'Ventilateur',
    'ar': 'مروحة',
    'zh': '风扇',
  },
  'clock': {
    'en': 'Clock',
    'ja': '時計',
    'bn': 'ঘড়ি',
    'es': 'Reloj',
    'fr': 'Horloge',
    'ar': 'ساعة',
    'zh': '时钟',
  },
  'keyboard': {
    'en': 'Keyboard',
    'ja': 'キーボード',
    'bn': 'কীবোর্ড',
    'es': 'Teclado',
    'fr': 'Clavier',
    'ar': 'لوحة المفاتيح',
    'zh': '键盘',
  },
  'wiper': {
    'en': 'Wiper',
    'ja': 'ワイパー',
    'bn': 'ওয়াইপার',
    'es': 'Limpiaparabrisas',
    'fr': 'Essuie-glace',
    'ar': 'مسّاحة',
    'zh': '雨刮器',
  },
  'cars_passing': {
    'en': 'Cars Passing',
    'ja': '通り過ぎる車',
    'bn': 'গাড়ি যাচ্ছে',
    'es': 'Coches pasando',
    'fr': 'Voitures passant',
    'ar': 'السيارات تمر',
    'zh': '汽车驶过',
  },
  'wind_chime': {
    'en': 'Wind Chime',
    'ja': '風鈴',
    'bn': 'বাতাসি',
    'es': 'Campanilla de viento',
    'fr': 'Carillon éolien',
    'ar': 'ناقوس الرياح',
    'zh': '风铃',
  },
  'meditation_bell': {
    'en': 'Meditation Bell',
    'ja': '瞑想ベル',
    'bn': 'ধ্যান বেল',
    'es': 'Campana de meditación',
    'fr': 'Cloche de méditation',
    'ar': 'جرس التأمل',
    'zh': '冥想铃',
  },
  'violin': {
    'en': 'Violin',
    'ja': 'バイオリン',
    'bn': 'ভায়োলিন',
    'es': 'Violín',
    'fr': 'Violon',
    'ar': 'كمان',
    'zh': '小提琴',
  },
  'harp': {
    'en': 'Harp',
    'ja': 'ハープ',
    'bn': 'হার্প',
    'es': 'Arpa',
    'fr': 'Harpe',
    'ar': 'قيثارة',
    'zh': '竖琴',
  },
  'guzheng': {
    'en': 'Guzheng',
    'ja': 'グージェン',
    'bn': 'গুজ়েং',
    'es': 'Guzheng',
    'fr': 'Guzheng',
    'ar': 'غوزهنغ',
    'zh': '古筝',
  },
  'brown_noise': {
    'en': 'Brown Noise',
    'ja': 'ブラウンノイズ',
    'bn': 'ব্রাউন নয়েজ',
    'es': 'Ruido marrón',
    'fr': 'Bruit brun',
    'ar': 'الضوضاء البنية',
    'zh': '棕噪音',
  },
  'pink_noise': {
    'en': 'Pink Noise',
    'ja': 'ピンクノイズ',
    'bn': 'পিঙ্ক নয়েজ',
    'es': 'Ruido rosa',
    'fr': 'Bruit rose',
    'ar': 'الضوضاء الوردية',
    'zh': '粉噪音',
  },
  'guitar': {
    'en': 'Guitar',
    'ja': 'ギター',
    'bn': 'গিটার',
    'es': 'Guitarra',
    'fr': 'Guitare',
    'ar': 'قيثارة',
    'zh': '吉他',
  },
  'piano': {
    'en': 'Piano',
    'ja': 'ピアノ',
    'bn': 'পিয়ানো',
    'es': 'Piano',
    'fr': 'Piano',
    'ar': 'بيانو',
    'zh': '钢琴',
  },
  'flute': {
    'en': 'Flute',
    'ja': 'フルート',
    'bn': 'বাঁশি',
    'es': 'Flauta',
    'fr': 'Flûte',
    'ar': 'ناي',
    'zh': '长笛',
  },
};

String tr(String key, Locale locale) =>
    localizedStrings[key]?[locale.languageCode] ??
    localizedStrings[key]?['en'] ??
    key;

// --- END Localization Section ---

// Sound definition with asset path (unchanged, but note: use tr for display names)
class SleepSound {
  final String keyName; // key for translation
  final IconData icon;
  final String asset;
  SleepSound({required this.keyName, required this.icon, required this.asset});
}

// Updated soundCategories with translation keys for names and categories
final List<_SoundCategory> soundCategories = [
  _SoundCategory(
    titleKey: 'rain_thunders',
    sounds: [
      SleepSound(keyName: 'light_rain', icon: Icons.grain, asset: "../assets/sounds/light_rain.mp3"),
      SleepSound(keyName: 'heavy_rain', icon: Icons.water_drop, asset: "../assets/sounds/heavy_rain.mp3"),
      SleepSound(keyName: 'thunder', icon: Icons.flash_on, asset: "../assets/sounds/thunder.mp3"),
      SleepSound(keyName: 'rain_on_umbrella', icon: Icons.umbrella, asset: "../assets/sounds/rain_umbrella.mp3"),
      SleepSound(keyName: 'rain_on_window', icon: Icons.window, asset: "../assets/sounds/rain_window.mp3"),
      SleepSound(keyName: 'snow', icon: Icons.ac_unit, asset: "../assets/sounds/snow.mp3"),
      SleepSound(keyName: 'rain_on_roof', icon: Icons.house, asset: "../assets/sounds/rain_roof.mp3"),
      SleepSound(keyName: 'rain_on_tent', icon: Icons.terrain, asset: "../assets/sounds/rain_tent.mp3"),
      SleepSound(keyName: 'rain_on_puddle', icon: Icons.pool, asset: "../assets/sounds/rain_puddle.mp3"),
    ],
  ),
  _SoundCategory(
    titleKey: 'nature',
    sounds: [
      SleepSound(keyName: 'ocean', icon: Icons.waves, asset: "../assets/sounds/ocean.mp3"),
      SleepSound(keyName: 'lake', icon: Icons.water, asset: "../assets/sounds/lake.mp3"),
      SleepSound(keyName: 'creek', icon: Icons.stream, asset: "../assets/sounds/creek.mp3"),
      SleepSound(keyName: 'forest', icon: Icons.forest, asset: "../assets/sounds/forest.mp3"),
      SleepSound(keyName: 'wind_leaves', icon: Icons.eco, asset: "../assets/sounds/wind_leaves.mp3"),
      SleepSound(keyName: 'wind', icon: Icons.air, asset: "../assets/sounds/wind.mp3"),
      SleepSound(keyName: 'waterfall', icon: Icons.waterfall_chart, asset: "../assets/sounds/waterfall.mp3"),
      SleepSound(keyName: 'drip', icon: Icons.opacity, asset: "../assets/sounds/drip.mp3"),
      SleepSound(keyName: 'underwater', icon: Icons.bubble_chart, asset: "../assets/sounds/underwater.mp3"),
      SleepSound(keyName: 'farm', icon: Icons.agriculture, asset: "../assets/sounds/farm.mp3"),
      SleepSound(keyName: 'grassland', icon: Icons.landscape, asset: "../assets/sounds/grassland.mp3"),
      SleepSound(keyName: 'fire', icon: Icons.local_fire_department, asset: "../assets/sounds/fire.mp3"),
    ],
  ),
  _SoundCategory(
    titleKey: 'animal',
    sounds: [
      SleepSound(keyName: 'bird', icon: Icons.filter_hdr, asset: "../assets/sounds/bird.mp3"),
      SleepSound(keyName: 'bird2', icon: Icons.filter_hdr, asset: "../assets/sounds/bird2.mp3"),
      SleepSound(keyName: 'seagull', icon: Icons.filter_hdr, asset: "../assets/sounds/seagull.mp3"),
      SleepSound(keyName: 'frog', icon: Icons.bug_report, asset: "../assets/sounds/frog.mp3"),
      SleepSound(keyName: 'frog2', icon: Icons.bug_report, asset: "../assets/sounds/frog2.mp3"),
      SleepSound(keyName: 'cricket', icon: Icons.bug_report, asset: "../assets/sounds/cricket.mp3"),
      SleepSound(keyName: 'cicada', icon: Icons.bug_report, asset: "../assets/sounds/cicada.mp3"),
      SleepSound(keyName: 'wolf', icon: Icons.pets, asset: "../assets/sounds/wolf.mp3"),
      SleepSound(keyName: 'loon', icon: Icons.filter_hdr, asset: "../assets/sounds/loon.mp3"),
      SleepSound(keyName: 'cat_purring', icon: Icons.pets, asset: "../assets/sounds/cat_purring.mp3"),
      SleepSound(keyName: 'whale', icon: Icons.waves, asset: "../assets/sounds/whale.mp3"),
      SleepSound(keyName: 'owl', icon: Icons.visibility, asset: "../assets/sounds/owl.mp3"),
    ],
  ),
  _SoundCategory(
    titleKey: 'transport',
    sounds: [
      SleepSound(keyName: 'train', icon: Icons.train, asset: "../assets/sounds/train.mp3"),
      SleepSound(keyName: 'car', icon: Icons.directions_car, asset: "../assets/sounds/car.mp3"),
      SleepSound(keyName: 'airplane', icon: Icons.flight, asset: "../assets/sounds/airplane.mp3"),
    ],
  ),
  _SoundCategory(
    titleKey: 'city_instrument',
    sounds: [
      SleepSound(keyName: 'construction_site', icon: Icons.construction, asset: "../assets/sounds/construction.mp3"),
      SleepSound(keyName: 'lullaby', icon: Icons.family_restroom, asset: "../assets/sounds/lullaby.mp3"),
      SleepSound(keyName: 'dryer', icon: Icons.local_laundry_service, asset: "../assets/sounds/dryer.mp3"),
      SleepSound(keyName: 'hair_dryer', icon: Icons.blender, asset: "../assets/sounds/hair_dryer.mp3"),
      SleepSound(keyName: 'vacuum_cleaner', icon: Icons.cleaning_services, asset: "../assets/sounds/vacuum.mp3"),
      SleepSound(keyName: 'fan', icon: Icons.toys, asset: "../assets/sounds/fan.mp3"),
      SleepSound(keyName: 'clock', icon: Icons.access_time, asset: "../assets/sounds/clock.mp3"),
      SleepSound(keyName: 'keyboard', icon: Icons.keyboard, asset: "../assets/sounds/keyboard.mp3"),
      SleepSound(keyName: 'wiper', icon: Icons.cleaning_services, asset: "../assets/sounds/wiper.mp3"),
      SleepSound(keyName: 'cars_passing', icon: Icons.directions_car, asset: "../assets/sounds/cars_passing.mp3"),
      SleepSound(keyName: 'wind_chime', icon: Icons.wind_power, asset: "../assets/sounds/wind_chime.mp3"),
      SleepSound(keyName: 'meditation_bell', icon: Icons.notifications, asset: "../assets/sounds/bell.mp3"),
      SleepSound(keyName: 'violin', icon: Icons.music_note, asset: "../assets/sounds/violin.mp3"),
      SleepSound(keyName: 'harp', icon: Icons.music_note, asset: "../assets/sounds/harp.mp3"),
      SleepSound(keyName: 'guzheng', icon: Icons.music_note, asset: "../assets/sounds/guzheng.mp3"),
    ],
  ),
  _SoundCategory(
    titleKey: 'white_noise',
    sounds: [
      SleepSound(keyName: 'white_noise', icon: Icons.surround_sound, asset: "../assets/sounds/white_noise.mp3"),
      SleepSound(keyName: 'brown_noise', icon: Icons.graphic_eq, asset: "../assets/sounds/brown_noise.mp3"),
      SleepSound(keyName: 'pink_noise', icon: Icons.multitrack_audio, asset: "../assets/sounds/pink_noise.mp3"),
    ],
  ),
  _SoundCategory(
    titleKey: 'meditation',
    sounds: [
      SleepSound(keyName: 'guitar', icon: Icons.music_note, asset: "../assets/sounds/guitar.mp3"),
      SleepSound(keyName: 'piano', icon: Icons.piano, asset: "../assets/sounds/piano.mp3"),
      SleepSound(keyName: 'flute', icon: Icons.music_note, asset: "../assets/sounds/flute.mp3"),
    ],
  ),
];

// --- Main App ---

class SleepSoundsScreen extends StatefulWidget {
  final RiseiTheme riseiTheme;
  final Locale locale;
  const SleepSoundsScreen({
    Key? key,
    required this.riseiTheme,
    required this.locale,
  }) : super(key: key);

  @override
  State<SleepSoundsScreen> createState() => _SleepSoundsScreenState();
}

class _SleepSoundsScreenState extends State<SleepSoundsScreen> {
  final Map<String, AudioPlayer> _players = {};
  final Map<String, double> _volumes = {};
  final Map<String, bool> _isPlaying = {};

  List<SleepSound> _customMix = [];
  Timer? _sleepTimer;
  DateTime? _timerEndTime;
  int _tabIndex = 0;

  @override
  void dispose() {
    for (var player in _players.values) {
      player.stop();
      player.dispose();
    }
    _sleepTimer?.cancel();
    super.dispose();
  }

  void _toggleSound(SleepSound sound) async {
    final key = sound.keyName;
    if (!mounted) return;
    setState(() {
      _isPlaying[key] = !(_isPlaying[key] ?? false);
    });

    if (_isPlaying[key] == true) {
      final player = AudioPlayer();
      _players[key] = player;
      _volumes[key] = 0.5;
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(0.5);
      await player.play(AssetSource(sound.asset));
    } else {
      if (_players.containsKey(key)) {
        await _players[key]?.stop();
        await _players[key]?.dispose();
        _players.remove(key);
      }
    }
    setState(() {});
  }

  void _setVolume(SleepSound sound, double value) {
    final key = sound.keyName;
    _volumes[key] = value;
    _players[key]?.setVolume(value);
    setState(() {});
  }

  void _addToCustomMix(SleepSound sound) {
    setState(() {
      if (!_customMix.contains(sound)) {
        _customMix.add(sound);
      }
    });
  }

  void _removeFromCustomMix(SleepSound sound) {
    setState(() {
      _customMix.remove(sound);
    });
  }

  void _stopAll() {
    for (final k in _players.keys.toList()) {
      _isPlaying[k] = false;
      _players[k]?.stop();
      _players[k]?.dispose();
    }
    _players.clear();
    _sleepTimer?.cancel();
    _timerEndTime = null;
    setState(() {});
  }

  void _showTimerDialog() async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(tr('set_sleep_timer', widget.locale)),
        children: [
          ...[10, 20, 30, 60].map((m) => SimpleDialogOption(
            child: Text('$m minutes'),
            onPressed: () => Navigator.of(context).pop(m),
          )),
          SimpleDialogOption(
            child: Text(tr('custom', widget.locale) + '...'),
            onPressed: () async {
              int custom = 30;
              final val = await showDialog<int>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(tr('custom_min', widget.locale)),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (val) => custom = int.tryParse(val) ?? 30,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(custom),
                        child: Text(tr('set', widget.locale)),
                      )
                    ],
                  );
                },
              );
              Navigator.of(context).pop(val);
            },
          ),
          SimpleDialogOption(
            child: Text(tr('cancel', widget.locale)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
    if (minutes != null && minutes > 0) {
      _setSleepTimer(minutes);
    }
  }

  void _setSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    _timerEndTime = DateTime.now().add(Duration(minutes: minutes));
    _sleepTimer = Timer(Duration(minutes: minutes), () {
      _stopAll();
      _timerEndTime = null;
      setState(() {});
    });
    setState(() {});
  }

  String get _timerLabel {
    if (_timerEndTime == null) return "No timer";
    final remaining = _timerEndTime!.difference(DateTime.now());
    if (remaining.isNegative) return "Timer ended";
    final min = remaining.inMinutes;
    final sec = remaining.inSeconds % 60;
    return "Timer: ${min}m ${sec}s left";
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.riseiTheme;
    final locale = widget.locale;

    return Scaffold(
      backgroundColor: theme.backgroundGradient.colors[0],
      appBar: AppBar(
        title: Text(tr('sleep_sounds', locale)),
        backgroundColor: theme.backgroundGradient.colors[1],
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            tooltip: tr('set_sleep_timer', locale),
            onPressed: _showTimerDialog,
          ),
          if (_timerEndTime != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  _timerLabel,
                  style: TextStyle(color: theme.accentYellow, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.stop_circle),
            tooltip: tr('stop_all_sounds', locale),
            onPressed: _stopAll,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: theme.backgroundGradient),
          child: IndexedStack(
            index: _tabIndex,
            children: [
              // Tab 0: All Sounds
              ListView(
                padding: const EdgeInsets.only(top: 12, left: 10, right: 10, bottom: 60),
                children: [
                  ...soundCategories.map(
                    (cat) => _SoundCategoryWidget(
                      category: cat,
                      theme: theme,
                      isPlaying: _isPlaying,
                      volumes: _volumes,
                      onPlayPause: _toggleSound,
                      onVolume: _setVolume,
                      onAddToCustom: _addToCustomMix,
                      customMix: _customMix,
                      locale: locale,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _tabIndex = 1;
                        });
                      },
                      icon: const Icon(Icons.tune),
                      label: Text(tr('go_to_custom_mix', locale)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: theme.accentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                ],
              ),
              // Tab 1: Custom (Mix)
              _CustomMixScreen(
                customMix: _customMix,
                isPlaying: _isPlaying,
                volumes: _volumes,
                theme: theme,
                onPlayPause: _toggleSound,
                onVolume: _setVolume,
                onRemove: _removeFromCustomMix,
                onBack: () => setState(() => _tabIndex = 0),
                onStopAll: _stopAll,
                locale: locale,
              ),
              // Tab 2: Settings
              _SleepSoundSettings(
                theme: theme,
                onStopAll: _stopAll,
                locale: locale,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: theme.accentYellow,
        unselectedItemColor: theme.textFaint,
        currentIndex: _tabIndex,
        onTap: (index) => setState(() => _tabIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: tr('sounds', locale),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune),
            label: tr('custom', locale),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: tr('settings', locale),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _SoundCategoryWidget extends StatelessWidget {
  final _SoundCategory category;
  final RiseiTheme theme;
  final Map<String, bool> isPlaying;
  final Map<String, double> volumes;
  final Function(SleepSound) onPlayPause;
  final Function(SleepSound, double) onVolume;
  final Function(SleepSound) onAddToCustom;
  final List<SleepSound> customMix;
  final Locale locale;

  const _SoundCategoryWidget({
    required this.category,
    required this.theme,
    required this.isPlaying,
    required this.volumes,
    required this.onPlayPause,
    required this.onVolume,
    required this.onAddToCustom,
    required this.customMix,
    required this.locale,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.titleKey.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6),
            child: Text(
              tr(category.titleKey, locale),
              style: TextStyle(
                  color: theme.accentYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1),
            ),
          ),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1,
          children: [
            ...category.sounds.map(
              (sound) => _SoundIconButton(
                sound: sound,
                isPlaying: isPlaying[sound.keyName] ?? false,
                volume: volumes[sound.keyName] ?? 0.5,
                theme: theme,
                onPlayPause: () => onPlayPause(sound),
                onVolume: (v) => onVolume(sound, v),
                onAddToCustom: () => onAddToCustom(sound),
                customActive: customMix.contains(sound),
                locale: locale,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

class _SoundIconButton extends StatelessWidget {
  final SleepSound sound;
  final bool isPlaying;
  final double volume;
  final RiseiTheme theme;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onVolume;
  final VoidCallback onAddToCustom;
  final bool customActive;
  final Locale locale;

  const _SoundIconButton({
    required this.sound,
    required this.isPlaying,
    required this.volume,
    required this.theme,
    required this.onPlayPause,
    required this.onVolume,
    required this.onAddToCustom,
    required this.customActive,
    required this.locale,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPlayPause,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isPlaying
                ? theme.accentBlue.withOpacity(0.7)
                : Colors.white.withOpacity(0.06),
            boxShadow: isPlaying
                ? [
                    BoxShadow(
                      color: theme.accentBlue.withOpacity(0.25),
                      blurRadius: 16,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                sound.icon,
                color: isPlaying
                    ? Colors.white
                    : theme.accentCyan.withOpacity(0.9),
                size: 38,
              ),
              const SizedBox(height: 8),
              Text(
                tr(sound.keyName, locale),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isPlaying
                      ? Colors.white
                      : theme.textWhite.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              if (isPlaying)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.pause_circle_filled,
                          color: Colors.white, size: 22),
                    ),
                    Slider(
                      value: volume,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onVolume,
                      activeColor: theme.accentYellow,
                      inactiveColor: theme.accentYellow.withOpacity(0.5),
                    ),
                  ],
                ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () {
                  if (!customActive) {
                    onAddToCustom();
                  }
                },
                child: Icon(
                  customActive ? Icons.star : Icons.star_border,
                  size: 18,
                  color: customActive
                      ? theme.accentYellow
                      : theme.textFaint.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomMixScreen extends StatelessWidget {
  final List<SleepSound> customMix;
  final Map<String, bool> isPlaying;
  final Map<String, double> volumes;
  final RiseiTheme theme;
  final Function(SleepSound) onPlayPause;
  final Function(SleepSound, double) onVolume;
  final Function(SleepSound) onRemove;
  final VoidCallback onBack;
  final VoidCallback onStopAll;
  final Locale locale;

  const _CustomMixScreen({
    required this.customMix,
    required this.isPlaying,
    required this.volumes,
    required this.theme,
    required this.onPlayPause,
    required this.onVolume,
    required this.onRemove,
    required this.onBack,
    required this.onStopAll,
    required this.locale,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: theme.accentYellow),
                onPressed: onBack,
                tooltip: tr('sounds', locale),
              ),
              Text(
                tr('custom_mix', locale),
                style: TextStyle(
                    color: theme.accentYellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.stop_circle, color: theme.accentCyan),
                onPressed: onStopAll,
                tooltip: tr('stop_all_sounds', locale),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: customMix.isEmpty
                ? Center(
                    child: Text(
                      tr('no_sounds_mix', locale),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.textFaint, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 0, bottom: 80),
                    itemCount: customMix.length,
                    itemBuilder: (context, i) {
                      final sound = customMix[i];
                      final playing = isPlaying[sound.keyName] ?? false;
                      final volume = volumes[sound.keyName] ?? 0.5;
                      return Card(
                        color: playing
                            ? theme.accentBlue.withOpacity(0.6)
                            : theme.backgroundGradient.colors[0].withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: Icon(sound.icon,
                              size: 33,
                              color: playing
                                  ? Colors.white
                                  : theme.accentCyan.withOpacity(0.9)),
                          title: Text(
                            tr(sound.keyName, locale),
                            style: TextStyle(
                                color: playing
                                    ? Colors.white
                                    : theme.textWhite.withOpacity(0.85),
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: playing
                              ? Slider(
                                  value: volume,
                                  min: 0,
                                  max: 1.0,
                                  onChanged: (v) => onVolume(sound, v),
                                  activeColor: theme.accentYellow,
                                  inactiveColor:
                                      theme.accentYellow.withOpacity(0.5),
                                )
                              : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                    playing
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    color: theme.accentYellow),
                                onPressed: () => onPlayPause(sound),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => onRemove(sound),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SleepSoundSettings extends StatelessWidget {
  final RiseiTheme theme;
  final VoidCallback onStopAll;
  final Locale locale;
  const _SleepSoundSettings({required this.theme, required this.onStopAll, required this.locale, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(tr('settings', locale), style: TextStyle(color: theme.accentYellow, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        ListTile(
          leading: Icon(Icons.stop, color: theme.accentBlue),
          title: Text(tr('stop_all_sounds', locale)),
          onTap: onStopAll,
        ),
        ListTile(
          leading: Icon(Icons.info_outline, color: theme.accentYellow),
          title: Text(tr('app_version', locale)),
        ),
      ],
    );
  }
}

// Helper category structure
class _SoundCategory {
  final String titleKey;
  final List<SleepSound> sounds;
  const _SoundCategory({required this.titleKey, required this.sounds});
}
