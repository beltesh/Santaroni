// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmailTemplatesTable extends EmailTemplates
    with TableInfo<$EmailTemplatesTable, EmailTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TemplateFormat, String> format =
      GeneratedColumn<String>(
        'format',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TemplateFormat>($EmailTemplatesTable.$converterformat);
  @override
  late final GeneratedColumnWithTypeConverter<TemplateKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TemplateKind.assignment.name),
      ).withConverter<TemplateKind>($EmailTemplatesTable.$converterkind);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    fileName,
    format,
    kind,
    body,
    importedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      format: $EmailTemplatesTable.$converterformat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}format'],
        )!,
      ),
      kind: $EmailTemplatesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
    );
  }

  @override
  $EmailTemplatesTable createAlias(String alias) {
    return $EmailTemplatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TemplateFormat, String, String> $converterformat =
      const EnumNameConverter<TemplateFormat>(TemplateFormat.values);
  static JsonTypeConverter2<TemplateKind, String, String> $converterkind =
      const EnumNameConverter<TemplateKind>(TemplateKind.values);
}

class EmailTemplate extends DataClass implements Insertable<EmailTemplate> {
  final int id;

  /// Display name, from the file name without its extension.
  final String name;

  /// The imported file's name, shown so the user knows what to update.
  final String fileName;
  final TemplateFormat format;

  /// Assignment or cancellation email; each kind has its own variables.
  final TemplateKind kind;

  /// The file's contents, with `{{Variables}}`. Stored so that moving or
  /// deleting the original file doesn't break anything.
  final String body;
  final DateTime importedAt;
  const EmailTemplate({
    required this.id,
    required this.name,
    required this.fileName,
    required this.format,
    required this.kind,
    required this.body,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['file_name'] = Variable<String>(fileName);
    {
      map['format'] = Variable<String>(
        $EmailTemplatesTable.$converterformat.toSql(format),
      );
    }
    {
      map['kind'] = Variable<String>(
        $EmailTemplatesTable.$converterkind.toSql(kind),
      );
    }
    map['body'] = Variable<String>(body);
    map['imported_at'] = Variable<DateTime>(importedAt);
    return map;
  }

  EmailTemplatesCompanion toCompanion(bool nullToAbsent) {
    return EmailTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      fileName: Value(fileName),
      format: Value(format),
      kind: Value(kind),
      body: Value(body),
      importedAt: Value(importedAt),
    );
  }

  factory EmailTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailTemplate(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fileName: serializer.fromJson<String>(json['fileName']),
      format: $EmailTemplatesTable.$converterformat.fromJson(
        serializer.fromJson<String>(json['format']),
      ),
      kind: $EmailTemplatesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      body: serializer.fromJson<String>(json['body']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'fileName': serializer.toJson<String>(fileName),
      'format': serializer.toJson<String>(
        $EmailTemplatesTable.$converterformat.toJson(format),
      ),
      'kind': serializer.toJson<String>(
        $EmailTemplatesTable.$converterkind.toJson(kind),
      ),
      'body': serializer.toJson<String>(body),
      'importedAt': serializer.toJson<DateTime>(importedAt),
    };
  }

  EmailTemplate copyWith({
    int? id,
    String? name,
    String? fileName,
    TemplateFormat? format,
    TemplateKind? kind,
    String? body,
    DateTime? importedAt,
  }) => EmailTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    fileName: fileName ?? this.fileName,
    format: format ?? this.format,
    kind: kind ?? this.kind,
    body: body ?? this.body,
    importedAt: importedAt ?? this.importedAt,
  );
  EmailTemplate copyWithCompanion(EmailTemplatesCompanion data) {
    return EmailTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      format: data.format.present ? data.format.value : this.format,
      kind: data.kind.present ? data.kind.value : this.kind,
      body: data.body.present ? data.body.value : this.body,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fileName: $fileName, ')
          ..write('format: $format, ')
          ..write('kind: $kind, ')
          ..write('body: $body, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, fileName, format, kind, body, importedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.fileName == this.fileName &&
          other.format == this.format &&
          other.kind == this.kind &&
          other.body == this.body &&
          other.importedAt == this.importedAt);
}

class EmailTemplatesCompanion extends UpdateCompanion<EmailTemplate> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> fileName;
  final Value<TemplateFormat> format;
  final Value<TemplateKind> kind;
  final Value<String> body;
  final Value<DateTime> importedAt;
  const EmailTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fileName = const Value.absent(),
    this.format = const Value.absent(),
    this.kind = const Value.absent(),
    this.body = const Value.absent(),
    this.importedAt = const Value.absent(),
  });
  EmailTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String fileName,
    required TemplateFormat format,
    this.kind = const Value.absent(),
    required String body,
    this.importedAt = const Value.absent(),
  }) : name = Value(name),
       fileName = Value(fileName),
       format = Value(format),
       body = Value(body);
  static Insertable<EmailTemplate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? fileName,
    Expression<String>? format,
    Expression<String>? kind,
    Expression<String>? body,
    Expression<DateTime>? importedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fileName != null) 'file_name': fileName,
      if (format != null) 'format': format,
      if (kind != null) 'kind': kind,
      if (body != null) 'body': body,
      if (importedAt != null) 'imported_at': importedAt,
    });
  }

  EmailTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? fileName,
    Value<TemplateFormat>? format,
    Value<TemplateKind>? kind,
    Value<String>? body,
    Value<DateTime>? importedAt,
  }) {
    return EmailTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      format: format ?? this.format,
      kind: kind ?? this.kind,
      body: body ?? this.body,
      importedAt: importedAt ?? this.importedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(
        $EmailTemplatesTable.$converterformat.toSql(format.value),
      );
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $EmailTemplatesTable.$converterkind.toSql(kind.value),
      );
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fileName: $fileName, ')
          ..write('format: $format, ')
          ..write('kind: $kind, ')
          ..write('body: $body, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
    'event_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventTimeMeta = const VerificationMeta(
    'eventTime',
  );
  @override
  late final GeneratedColumn<String> eventTime = GeneratedColumn<String>(
    'event_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetMinorMeta = const VerificationMeta(
    'budgetMinor',
  );
  @override
  late final GeneratedColumn<int> budgetMinor = GeneratedColumn<int>(
    'budget_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_templates (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _emailSubjectMeta = const VerificationMeta(
    'emailSubject',
  );
  @override
  late final GeneratedColumn<String> emailSubject = GeneratedColumn<String>(
    'email_subject',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelNoteMeta = const VerificationMeta(
    'cancelNote',
  );
  @override
  late final GeneratedColumn<String> cancelNote = GeneratedColumn<String>(
    'cancel_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelTemplateIdMeta = const VerificationMeta(
    'cancelTemplateId',
  );
  @override
  late final GeneratedColumn<int> cancelTemplateId = GeneratedColumn<int>(
    'cancel_template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_templates (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _cancelSubjectMeta = const VerificationMeta(
    'cancelSubject',
  );
  @override
  late final GeneratedColumn<String> cancelSubject = GeneratedColumn<String>(
    'cancel_subject',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EventStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(EventStatus.draft.name),
      ).withConverter<EventStatus>($EventsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    slug,
    eventDate,
    eventTime,
    place,
    budgetMinor,
    currency,
    languageCode,
    templateId,
    emailSubject,
    archived,
    cancelledAt,
    cancelNote,
    cancelTemplateId,
    cancelSubject,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    }
    if (data.containsKey('event_time')) {
      context.handle(
        _eventTimeMeta,
        eventTime.isAcceptableOrUnknown(data['event_time']!, _eventTimeMeta),
      );
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('budget_minor')) {
      context.handle(
        _budgetMinorMeta,
        budgetMinor.isAcceptableOrUnknown(
          data['budget_minor']!,
          _budgetMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('email_subject')) {
      context.handle(
        _emailSubjectMeta,
        emailSubject.isAcceptableOrUnknown(
          data['email_subject']!,
          _emailSubjectMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    if (data.containsKey('cancel_note')) {
      context.handle(
        _cancelNoteMeta,
        cancelNote.isAcceptableOrUnknown(data['cancel_note']!, _cancelNoteMeta),
      );
    }
    if (data.containsKey('cancel_template_id')) {
      context.handle(
        _cancelTemplateIdMeta,
        cancelTemplateId.isAcceptableOrUnknown(
          data['cancel_template_id']!,
          _cancelTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('cancel_subject')) {
      context.handle(
        _cancelSubjectMeta,
        cancelSubject.isAcceptableOrUnknown(
          data['cancel_subject']!,
          _cancelSubjectMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_date'],
      ),
      eventTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_time'],
      ),
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      ),
      budgetMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_minor'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      ),
      emailSubject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_subject'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
      cancelNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_note'],
      ),
      cancelTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cancel_template_id'],
      ),
      cancelSubject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_subject'],
      ),
      status: $EventsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EventStatus, String, String> $converterstatus =
      const EnumNameConverter<EventStatus>(EventStatus.values);
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String name;

  /// Kebab-case form of [name], used for the JSON export file name.
  final String slug;

  /// Date of the gift exchange (date part only).
  final DateTime? eventDate;

  /// Time of day as "HH:mm", kept separate so a date can have no time.
  final String? eventTime;
  final String? place;

  /// Maximum gift budget in minor units (cents), avoiding float rounding.
  final int? budgetMinor;

  /// ISO 4217 currency code.
  final String currency;

  /// Language used for this event's emails.
  final String languageCode;

  /// Imported template for the email body, or null for the built-in one in
  /// [languageCode].
  final int? templateId;

  /// Subject line, may contain `{{Variables}}`. Null means the default
  /// subject for [languageCode].
  final String? emailSubject;

  /// Manually moved to "Completed". Only used for events without a date;
  /// dated events are completed once their date has passed.
  final bool archived;

  /// When the event was cancelled. Cancelling is final: the event is then
  /// completed (read-only), whatever its date.
  final DateTime? cancelledAt;

  /// The organizer's optional message in the cancellation email.
  final String? cancelNote;

  /// Imported cancellation template, or null for the built-in one. Kept so
  /// failed cancellation emails can be retried with the same template.
  final int? cancelTemplateId;

  /// Subject of the cancellation email, or null for the default.
  final String? cancelSubject;
  final EventStatus status;
  final DateTime createdAt;
  const Event({
    required this.id,
    required this.name,
    required this.slug,
    this.eventDate,
    this.eventTime,
    this.place,
    this.budgetMinor,
    required this.currency,
    required this.languageCode,
    this.templateId,
    this.emailSubject,
    required this.archived,
    this.cancelledAt,
    this.cancelNote,
    this.cancelTemplateId,
    this.cancelSubject,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || eventDate != null) {
      map['event_date'] = Variable<DateTime>(eventDate);
    }
    if (!nullToAbsent || eventTime != null) {
      map['event_time'] = Variable<String>(eventTime);
    }
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    if (!nullToAbsent || budgetMinor != null) {
      map['budget_minor'] = Variable<int>(budgetMinor);
    }
    map['currency'] = Variable<String>(currency);
    map['language_code'] = Variable<String>(languageCode);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    if (!nullToAbsent || emailSubject != null) {
      map['email_subject'] = Variable<String>(emailSubject);
    }
    map['archived'] = Variable<bool>(archived);
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    if (!nullToAbsent || cancelNote != null) {
      map['cancel_note'] = Variable<String>(cancelNote);
    }
    if (!nullToAbsent || cancelTemplateId != null) {
      map['cancel_template_id'] = Variable<int>(cancelTemplateId);
    }
    if (!nullToAbsent || cancelSubject != null) {
      map['cancel_subject'] = Variable<String>(cancelSubject);
    }
    {
      map['status'] = Variable<String>(
        $EventsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      eventDate: eventDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eventDate),
      eventTime: eventTime == null && nullToAbsent
          ? const Value.absent()
          : Value(eventTime),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      budgetMinor: budgetMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetMinor),
      currency: Value(currency),
      languageCode: Value(languageCode),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      emailSubject: emailSubject == null && nullToAbsent
          ? const Value.absent()
          : Value(emailSubject),
      archived: Value(archived),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
      cancelNote: cancelNote == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelNote),
      cancelTemplateId: cancelTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelTemplateId),
      cancelSubject: cancelSubject == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelSubject),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      eventDate: serializer.fromJson<DateTime?>(json['eventDate']),
      eventTime: serializer.fromJson<String?>(json['eventTime']),
      place: serializer.fromJson<String?>(json['place']),
      budgetMinor: serializer.fromJson<int?>(json['budgetMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      emailSubject: serializer.fromJson<String?>(json['emailSubject']),
      archived: serializer.fromJson<bool>(json['archived']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
      cancelNote: serializer.fromJson<String?>(json['cancelNote']),
      cancelTemplateId: serializer.fromJson<int?>(json['cancelTemplateId']),
      cancelSubject: serializer.fromJson<String?>(json['cancelSubject']),
      status: $EventsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'eventDate': serializer.toJson<DateTime?>(eventDate),
      'eventTime': serializer.toJson<String?>(eventTime),
      'place': serializer.toJson<String?>(place),
      'budgetMinor': serializer.toJson<int?>(budgetMinor),
      'currency': serializer.toJson<String>(currency),
      'languageCode': serializer.toJson<String>(languageCode),
      'templateId': serializer.toJson<int?>(templateId),
      'emailSubject': serializer.toJson<String?>(emailSubject),
      'archived': serializer.toJson<bool>(archived),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
      'cancelNote': serializer.toJson<String?>(cancelNote),
      'cancelTemplateId': serializer.toJson<int?>(cancelTemplateId),
      'cancelSubject': serializer.toJson<String?>(cancelSubject),
      'status': serializer.toJson<String>(
        $EventsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Event copyWith({
    int? id,
    String? name,
    String? slug,
    Value<DateTime?> eventDate = const Value.absent(),
    Value<String?> eventTime = const Value.absent(),
    Value<String?> place = const Value.absent(),
    Value<int?> budgetMinor = const Value.absent(),
    String? currency,
    String? languageCode,
    Value<int?> templateId = const Value.absent(),
    Value<String?> emailSubject = const Value.absent(),
    bool? archived,
    Value<DateTime?> cancelledAt = const Value.absent(),
    Value<String?> cancelNote = const Value.absent(),
    Value<int?> cancelTemplateId = const Value.absent(),
    Value<String?> cancelSubject = const Value.absent(),
    EventStatus? status,
    DateTime? createdAt,
  }) => Event(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    eventDate: eventDate.present ? eventDate.value : this.eventDate,
    eventTime: eventTime.present ? eventTime.value : this.eventTime,
    place: place.present ? place.value : this.place,
    budgetMinor: budgetMinor.present ? budgetMinor.value : this.budgetMinor,
    currency: currency ?? this.currency,
    languageCode: languageCode ?? this.languageCode,
    templateId: templateId.present ? templateId.value : this.templateId,
    emailSubject: emailSubject.present ? emailSubject.value : this.emailSubject,
    archived: archived ?? this.archived,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
    cancelNote: cancelNote.present ? cancelNote.value : this.cancelNote,
    cancelTemplateId: cancelTemplateId.present
        ? cancelTemplateId.value
        : this.cancelTemplateId,
    cancelSubject: cancelSubject.present
        ? cancelSubject.value
        : this.cancelSubject,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      eventTime: data.eventTime.present ? data.eventTime.value : this.eventTime,
      place: data.place.present ? data.place.value : this.place,
      budgetMinor: data.budgetMinor.present
          ? data.budgetMinor.value
          : this.budgetMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      emailSubject: data.emailSubject.present
          ? data.emailSubject.value
          : this.emailSubject,
      archived: data.archived.present ? data.archived.value : this.archived,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
      cancelNote: data.cancelNote.present
          ? data.cancelNote.value
          : this.cancelNote,
      cancelTemplateId: data.cancelTemplateId.present
          ? data.cancelTemplateId.value
          : this.cancelTemplateId,
      cancelSubject: data.cancelSubject.present
          ? data.cancelSubject.value
          : this.cancelSubject,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('eventDate: $eventDate, ')
          ..write('eventTime: $eventTime, ')
          ..write('place: $place, ')
          ..write('budgetMinor: $budgetMinor, ')
          ..write('currency: $currency, ')
          ..write('languageCode: $languageCode, ')
          ..write('templateId: $templateId, ')
          ..write('emailSubject: $emailSubject, ')
          ..write('archived: $archived, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelNote: $cancelNote, ')
          ..write('cancelTemplateId: $cancelTemplateId, ')
          ..write('cancelSubject: $cancelSubject, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    slug,
    eventDate,
    eventTime,
    place,
    budgetMinor,
    currency,
    languageCode,
    templateId,
    emailSubject,
    archived,
    cancelledAt,
    cancelNote,
    cancelTemplateId,
    cancelSubject,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.eventDate == this.eventDate &&
          other.eventTime == this.eventTime &&
          other.place == this.place &&
          other.budgetMinor == this.budgetMinor &&
          other.currency == this.currency &&
          other.languageCode == this.languageCode &&
          other.templateId == this.templateId &&
          other.emailSubject == this.emailSubject &&
          other.archived == this.archived &&
          other.cancelledAt == this.cancelledAt &&
          other.cancelNote == this.cancelNote &&
          other.cancelTemplateId == this.cancelTemplateId &&
          other.cancelSubject == this.cancelSubject &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<DateTime?> eventDate;
  final Value<String?> eventTime;
  final Value<String?> place;
  final Value<int?> budgetMinor;
  final Value<String> currency;
  final Value<String> languageCode;
  final Value<int?> templateId;
  final Value<String?> emailSubject;
  final Value<bool> archived;
  final Value<DateTime?> cancelledAt;
  final Value<String?> cancelNote;
  final Value<int?> cancelTemplateId;
  final Value<String?> cancelSubject;
  final Value<EventStatus> status;
  final Value<DateTime> createdAt;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.eventTime = const Value.absent(),
    this.place = const Value.absent(),
    this.budgetMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.templateId = const Value.absent(),
    this.emailSubject = const Value.absent(),
    this.archived = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelNote = const Value.absent(),
    this.cancelTemplateId = const Value.absent(),
    this.cancelSubject = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String slug,
    this.eventDate = const Value.absent(),
    this.eventTime = const Value.absent(),
    this.place = const Value.absent(),
    this.budgetMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.templateId = const Value.absent(),
    this.emailSubject = const Value.absent(),
    this.archived = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.cancelNote = const Value.absent(),
    this.cancelTemplateId = const Value.absent(),
    this.cancelSubject = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       slug = Value(slug);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<DateTime>? eventDate,
    Expression<String>? eventTime,
    Expression<String>? place,
    Expression<int>? budgetMinor,
    Expression<String>? currency,
    Expression<String>? languageCode,
    Expression<int>? templateId,
    Expression<String>? emailSubject,
    Expression<bool>? archived,
    Expression<DateTime>? cancelledAt,
    Expression<String>? cancelNote,
    Expression<int>? cancelTemplateId,
    Expression<String>? cancelSubject,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (eventDate != null) 'event_date': eventDate,
      if (eventTime != null) 'event_time': eventTime,
      if (place != null) 'place': place,
      if (budgetMinor != null) 'budget_minor': budgetMinor,
      if (currency != null) 'currency': currency,
      if (languageCode != null) 'language_code': languageCode,
      if (templateId != null) 'template_id': templateId,
      if (emailSubject != null) 'email_subject': emailSubject,
      if (archived != null) 'archived': archived,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (cancelNote != null) 'cancel_note': cancelNote,
      if (cancelTemplateId != null) 'cancel_template_id': cancelTemplateId,
      if (cancelSubject != null) 'cancel_subject': cancelSubject,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EventsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? slug,
    Value<DateTime?>? eventDate,
    Value<String?>? eventTime,
    Value<String?>? place,
    Value<int?>? budgetMinor,
    Value<String>? currency,
    Value<String>? languageCode,
    Value<int?>? templateId,
    Value<String?>? emailSubject,
    Value<bool>? archived,
    Value<DateTime?>? cancelledAt,
    Value<String?>? cancelNote,
    Value<int?>? cancelTemplateId,
    Value<String?>? cancelSubject,
    Value<EventStatus>? status,
    Value<DateTime>? createdAt,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      place: place ?? this.place,
      budgetMinor: budgetMinor ?? this.budgetMinor,
      currency: currency ?? this.currency,
      languageCode: languageCode ?? this.languageCode,
      templateId: templateId ?? this.templateId,
      emailSubject: emailSubject ?? this.emailSubject,
      archived: archived ?? this.archived,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelNote: cancelNote ?? this.cancelNote,
      cancelTemplateId: cancelTemplateId ?? this.cancelTemplateId,
      cancelSubject: cancelSubject ?? this.cancelSubject,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (eventTime.present) {
      map['event_time'] = Variable<String>(eventTime.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (budgetMinor.present) {
      map['budget_minor'] = Variable<int>(budgetMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (emailSubject.present) {
      map['email_subject'] = Variable<String>(emailSubject.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (cancelNote.present) {
      map['cancel_note'] = Variable<String>(cancelNote.value);
    }
    if (cancelTemplateId.present) {
      map['cancel_template_id'] = Variable<int>(cancelTemplateId.value);
    }
    if (cancelSubject.present) {
      map['cancel_subject'] = Variable<String>(cancelSubject.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $EventsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('eventDate: $eventDate, ')
          ..write('eventTime: $eventTime, ')
          ..write('place: $place, ')
          ..write('budgetMinor: $budgetMinor, ')
          ..write('currency: $currency, ')
          ..write('languageCode: $languageCode, ')
          ..write('templateId: $templateId, ')
          ..write('emailSubject: $emailSubject, ')
          ..write('archived: $archived, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('cancelNote: $cancelNote, ')
          ..write('cancelTemplateId: $cancelTemplateId, ')
          ..write('cancelSubject: $cancelSubject, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ParticipantsTable extends Participants
    with TableInfo<$ParticipantsTable, Participant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParticipantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupTagMeta = const VerificationMeta(
    'groupTag',
  );
  @override
  late final GeneratedColumn<String> groupTag = GeneratedColumn<String>(
    'group_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventId, name, email, groupTag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'participants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Participant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('group_tag')) {
      context.handle(
        _groupTagMeta,
        groupTag.isAcceptableOrUnknown(data['group_tag']!, _groupTagMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Participant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Participant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      groupTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_tag'],
      ),
    );
  }

  @override
  $ParticipantsTable createAlias(String alias) {
    return $ParticipantsTable(attachedDatabase, alias);
  }
}

class Participant extends DataClass implements Insertable<Participant> {
  final int id;
  final int eventId;
  final String name;
  final String email;

  /// Optional exclusion group: people sharing a tag never draw each other.
  final String? groupTag;
  const Participant({
    required this.id,
    required this.eventId,
    required this.name,
    required this.email,
    this.groupTag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || groupTag != null) {
      map['group_tag'] = Variable<String>(groupTag);
    }
    return map;
  }

  ParticipantsCompanion toCompanion(bool nullToAbsent) {
    return ParticipantsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      name: Value(name),
      email: Value(email),
      groupTag: groupTag == null && nullToAbsent
          ? const Value.absent()
          : Value(groupTag),
    );
  }

  factory Participant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Participant(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      groupTag: serializer.fromJson<String?>(json['groupTag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'groupTag': serializer.toJson<String?>(groupTag),
    };
  }

  Participant copyWith({
    int? id,
    int? eventId,
    String? name,
    String? email,
    Value<String?> groupTag = const Value.absent(),
  }) => Participant(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    name: name ?? this.name,
    email: email ?? this.email,
    groupTag: groupTag.present ? groupTag.value : this.groupTag,
  );
  Participant copyWithCompanion(ParticipantsCompanion data) {
    return Participant(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      groupTag: data.groupTag.present ? data.groupTag.value : this.groupTag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Participant(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('groupTag: $groupTag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventId, name, email, groupTag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Participant &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.name == this.name &&
          other.email == this.email &&
          other.groupTag == this.groupTag);
}

class ParticipantsCompanion extends UpdateCompanion<Participant> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> groupTag;
  const ParticipantsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.groupTag = const Value.absent(),
  });
  ParticipantsCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required String name,
    required String email,
    this.groupTag = const Value.absent(),
  }) : eventId = Value(eventId),
       name = Value(name),
       email = Value(email);
  static Insertable<Participant> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? groupTag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (groupTag != null) 'group_tag': groupTag,
    });
  }

  ParticipantsCompanion copyWith({
    Value<int>? id,
    Value<int>? eventId,
    Value<String>? name,
    Value<String>? email,
    Value<String?>? groupTag,
  }) {
    return ParticipantsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      name: name ?? this.name,
      email: email ?? this.email,
      groupTag: groupTag ?? this.groupTag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (groupTag.present) {
      map['group_tag'] = Variable<String>(groupTag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('groupTag: $groupTag')
          ..write(')'))
        .toString();
  }
}

class $WishlistItemsTable extends WishlistItems
    with TableInfo<$WishlistItemsTable, WishlistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WishlistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _participantIdMeta = const VerificationMeta(
    'participantId',
  );
  @override
  late final GeneratedColumn<int> participantId = GeneratedColumn<int>(
    'participant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES participants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTextMeta = const VerificationMeta(
    'itemText',
  );
  @override
  late final GeneratedColumn<String> itemText = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    participantId,
    position,
    itemText,
    url,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wishlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WishlistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('participant_id')) {
      context.handle(
        _participantIdMeta,
        participantId.isAcceptableOrUnknown(
          data['participant_id']!,
          _participantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_participantIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _itemTextMeta,
        itemText.isAcceptableOrUnknown(data['text']!, _itemTextMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTextMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WishlistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WishlistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      participantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}participant_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      itemText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
    );
  }

  @override
  $WishlistItemsTable createAlias(String alias) {
    return $WishlistItemsTable(attachedDatabase, alias);
  }
}

class WishlistItem extends DataClass implements Insertable<WishlistItem> {
  final int id;
  final int participantId;
  final int position;
  final String itemText;
  final String? url;
  const WishlistItem({
    required this.id,
    required this.participantId,
    required this.position,
    required this.itemText,
    this.url,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['participant_id'] = Variable<int>(participantId);
    map['position'] = Variable<int>(position);
    map['text'] = Variable<String>(itemText);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    return map;
  }

  WishlistItemsCompanion toCompanion(bool nullToAbsent) {
    return WishlistItemsCompanion(
      id: Value(id),
      participantId: Value(participantId),
      position: Value(position),
      itemText: Value(itemText),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
    );
  }

  factory WishlistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WishlistItem(
      id: serializer.fromJson<int>(json['id']),
      participantId: serializer.fromJson<int>(json['participantId']),
      position: serializer.fromJson<int>(json['position']),
      itemText: serializer.fromJson<String>(json['itemText']),
      url: serializer.fromJson<String?>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'participantId': serializer.toJson<int>(participantId),
      'position': serializer.toJson<int>(position),
      'itemText': serializer.toJson<String>(itemText),
      'url': serializer.toJson<String?>(url),
    };
  }

  WishlistItem copyWith({
    int? id,
    int? participantId,
    int? position,
    String? itemText,
    Value<String?> url = const Value.absent(),
  }) => WishlistItem(
    id: id ?? this.id,
    participantId: participantId ?? this.participantId,
    position: position ?? this.position,
    itemText: itemText ?? this.itemText,
    url: url.present ? url.value : this.url,
  );
  WishlistItem copyWithCompanion(WishlistItemsCompanion data) {
    return WishlistItem(
      id: data.id.present ? data.id.value : this.id,
      participantId: data.participantId.present
          ? data.participantId.value
          : this.participantId,
      position: data.position.present ? data.position.value : this.position,
      itemText: data.itemText.present ? data.itemText.value : this.itemText,
      url: data.url.present ? data.url.value : this.url,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItem(')
          ..write('id: $id, ')
          ..write('participantId: $participantId, ')
          ..write('position: $position, ')
          ..write('itemText: $itemText, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, participantId, position, itemText, url);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WishlistItem &&
          other.id == this.id &&
          other.participantId == this.participantId &&
          other.position == this.position &&
          other.itemText == this.itemText &&
          other.url == this.url);
}

class WishlistItemsCompanion extends UpdateCompanion<WishlistItem> {
  final Value<int> id;
  final Value<int> participantId;
  final Value<int> position;
  final Value<String> itemText;
  final Value<String?> url;
  const WishlistItemsCompanion({
    this.id = const Value.absent(),
    this.participantId = const Value.absent(),
    this.position = const Value.absent(),
    this.itemText = const Value.absent(),
    this.url = const Value.absent(),
  });
  WishlistItemsCompanion.insert({
    this.id = const Value.absent(),
    required int participantId,
    required int position,
    required String itemText,
    this.url = const Value.absent(),
  }) : participantId = Value(participantId),
       position = Value(position),
       itemText = Value(itemText);
  static Insertable<WishlistItem> custom({
    Expression<int>? id,
    Expression<int>? participantId,
    Expression<int>? position,
    Expression<String>? itemText,
    Expression<String>? url,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (participantId != null) 'participant_id': participantId,
      if (position != null) 'position': position,
      if (itemText != null) 'text': itemText,
      if (url != null) 'url': url,
    });
  }

  WishlistItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? participantId,
    Value<int>? position,
    Value<String>? itemText,
    Value<String?>? url,
  }) {
    return WishlistItemsCompanion(
      id: id ?? this.id,
      participantId: participantId ?? this.participantId,
      position: position ?? this.position,
      itemText: itemText ?? this.itemText,
      url: url ?? this.url,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (participantId.present) {
      map['participant_id'] = Variable<int>(participantId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (itemText.present) {
      map['text'] = Variable<String>(itemText.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WishlistItemsCompanion(')
          ..write('id: $id, ')
          ..write('participantId: $participantId, ')
          ..write('position: $position, ')
          ..write('itemText: $itemText, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }
}

class $AssignmentsTable extends Assignments
    with TableInfo<$AssignmentsTable, Assignment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssignmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _giverIdMeta = const VerificationMeta(
    'giverId',
  );
  @override
  late final GeneratedColumn<int> giverId = GeneratedColumn<int>(
    'giver_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES participants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _recipientIdMeta = const VerificationMeta(
    'recipientId',
  );
  @override
  late final GeneratedColumn<int> recipientId = GeneratedColumn<int>(
    'recipient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES participants (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SendStatus, String> sendStatus =
      GeneratedColumn<String>(
        'send_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SendStatus.pending.name),
      ).withConverter<SendStatus>($AssignmentsTable.$convertersendStatus);
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    giverId,
    recipientId,
    sendStatus,
    sentAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assignments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Assignment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('giver_id')) {
      context.handle(
        _giverIdMeta,
        giverId.isAcceptableOrUnknown(data['giver_id']!, _giverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_giverIdMeta);
    }
    if (data.containsKey('recipient_id')) {
      context.handle(
        _recipientIdMeta,
        recipientId.isAcceptableOrUnknown(
          data['recipient_id']!,
          _recipientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientIdMeta);
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId, giverId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {eventId, recipientId},
  ];
  @override
  Assignment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Assignment(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_id'],
      )!,
      giverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}giver_id'],
      )!,
      recipientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipient_id'],
      )!,
      sendStatus: $AssignmentsTable.$convertersendStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}send_status'],
        )!,
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $AssignmentsTable createAlias(String alias) {
    return $AssignmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SendStatus, String, String> $convertersendStatus =
      const EnumNameConverter<SendStatus>(SendStatus.values);
}

class Assignment extends DataClass implements Insertable<Assignment> {
  final int eventId;
  final int giverId;

  /// Restrict, not cascade: removing someone who is a recipient must go
  /// through a splice first, so their giver is never silently left without
  /// an assignment.
  final int recipientId;
  final SendStatus sendStatus;
  final DateTime? sentAt;
  final String? lastError;
  const Assignment({
    required this.eventId,
    required this.giverId,
    required this.recipientId,
    required this.sendStatus,
    this.sentAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<int>(eventId);
    map['giver_id'] = Variable<int>(giverId);
    map['recipient_id'] = Variable<int>(recipientId);
    {
      map['send_status'] = Variable<String>(
        $AssignmentsTable.$convertersendStatus.toSql(sendStatus),
      );
    }
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  AssignmentsCompanion toCompanion(bool nullToAbsent) {
    return AssignmentsCompanion(
      eventId: Value(eventId),
      giverId: Value(giverId),
      recipientId: Value(recipientId),
      sendStatus: Value(sendStatus),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory Assignment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Assignment(
      eventId: serializer.fromJson<int>(json['eventId']),
      giverId: serializer.fromJson<int>(json['giverId']),
      recipientId: serializer.fromJson<int>(json['recipientId']),
      sendStatus: $AssignmentsTable.$convertersendStatus.fromJson(
        serializer.fromJson<String>(json['sendStatus']),
      ),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<int>(eventId),
      'giverId': serializer.toJson<int>(giverId),
      'recipientId': serializer.toJson<int>(recipientId),
      'sendStatus': serializer.toJson<String>(
        $AssignmentsTable.$convertersendStatus.toJson(sendStatus),
      ),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  Assignment copyWith({
    int? eventId,
    int? giverId,
    int? recipientId,
    SendStatus? sendStatus,
    Value<DateTime?> sentAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => Assignment(
    eventId: eventId ?? this.eventId,
    giverId: giverId ?? this.giverId,
    recipientId: recipientId ?? this.recipientId,
    sendStatus: sendStatus ?? this.sendStatus,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  Assignment copyWithCompanion(AssignmentsCompanion data) {
    return Assignment(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      giverId: data.giverId.present ? data.giverId.value : this.giverId,
      recipientId: data.recipientId.present
          ? data.recipientId.value
          : this.recipientId,
      sendStatus: data.sendStatus.present
          ? data.sendStatus.value
          : this.sendStatus,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Assignment(')
          ..write('eventId: $eventId, ')
          ..write('giverId: $giverId, ')
          ..write('recipientId: $recipientId, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('sentAt: $sentAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(eventId, giverId, recipientId, sendStatus, sentAt, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Assignment &&
          other.eventId == this.eventId &&
          other.giverId == this.giverId &&
          other.recipientId == this.recipientId &&
          other.sendStatus == this.sendStatus &&
          other.sentAt == this.sentAt &&
          other.lastError == this.lastError);
}

class AssignmentsCompanion extends UpdateCompanion<Assignment> {
  final Value<int> eventId;
  final Value<int> giverId;
  final Value<int> recipientId;
  final Value<SendStatus> sendStatus;
  final Value<DateTime?> sentAt;
  final Value<String?> lastError;
  final Value<int> rowid;
  const AssignmentsCompanion({
    this.eventId = const Value.absent(),
    this.giverId = const Value.absent(),
    this.recipientId = const Value.absent(),
    this.sendStatus = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssignmentsCompanion.insert({
    required int eventId,
    required int giverId,
    required int recipientId,
    this.sendStatus = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       giverId = Value(giverId),
       recipientId = Value(recipientId);
  static Insertable<Assignment> custom({
    Expression<int>? eventId,
    Expression<int>? giverId,
    Expression<int>? recipientId,
    Expression<String>? sendStatus,
    Expression<DateTime>? sentAt,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (giverId != null) 'giver_id': giverId,
      if (recipientId != null) 'recipient_id': recipientId,
      if (sendStatus != null) 'send_status': sendStatus,
      if (sentAt != null) 'sent_at': sentAt,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssignmentsCompanion copyWith({
    Value<int>? eventId,
    Value<int>? giverId,
    Value<int>? recipientId,
    Value<SendStatus>? sendStatus,
    Value<DateTime?>? sentAt,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return AssignmentsCompanion(
      eventId: eventId ?? this.eventId,
      giverId: giverId ?? this.giverId,
      recipientId: recipientId ?? this.recipientId,
      sendStatus: sendStatus ?? this.sendStatus,
      sentAt: sentAt ?? this.sentAt,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (giverId.present) {
      map['giver_id'] = Variable<int>(giverId.value);
    }
    if (recipientId.present) {
      map['recipient_id'] = Variable<int>(recipientId.value);
    }
    if (sendStatus.present) {
      map['send_status'] = Variable<String>(
        $AssignmentsTable.$convertersendStatus.toSql(sendStatus.value),
      );
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssignmentsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('giverId: $giverId, ')
          ..write('recipientId: $recipientId, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('sentAt: $sentAt, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CancellationNoticesTable extends CancellationNotices
    with TableInfo<$CancellationNoticesTable, CancellationNotice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CancellationNoticesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _participantIdMeta = const VerificationMeta(
    'participantId',
  );
  @override
  late final GeneratedColumn<int> participantId = GeneratedColumn<int>(
    'participant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES participants (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SendStatus, String> sendStatus =
      GeneratedColumn<String>(
        'send_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SendStatus.pending.name),
      ).withConverter<SendStatus>(
        $CancellationNoticesTable.$convertersendStatus,
      );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    participantId,
    sendStatus,
    sentAt,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cancellation_notices';
  @override
  VerificationContext validateIntegrity(
    Insertable<CancellationNotice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('participant_id')) {
      context.handle(
        _participantIdMeta,
        participantId.isAcceptableOrUnknown(
          data['participant_id']!,
          _participantIdMeta,
        ),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {participantId};
  @override
  CancellationNotice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CancellationNotice(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_id'],
      )!,
      participantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}participant_id'],
      )!,
      sendStatus: $CancellationNoticesTable.$convertersendStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}send_status'],
        )!,
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $CancellationNoticesTable createAlias(String alias) {
    return $CancellationNoticesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SendStatus, String, String> $convertersendStatus =
      const EnumNameConverter<SendStatus>(SendStatus.values);
}

class CancellationNotice extends DataClass
    implements Insertable<CancellationNotice> {
  final int eventId;
  final int participantId;
  final SendStatus sendStatus;
  final DateTime? sentAt;
  final String? lastError;
  const CancellationNotice({
    required this.eventId,
    required this.participantId,
    required this.sendStatus,
    this.sentAt,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<int>(eventId);
    map['participant_id'] = Variable<int>(participantId);
    {
      map['send_status'] = Variable<String>(
        $CancellationNoticesTable.$convertersendStatus.toSql(sendStatus),
      );
    }
    if (!nullToAbsent || sentAt != null) {
      map['sent_at'] = Variable<DateTime>(sentAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  CancellationNoticesCompanion toCompanion(bool nullToAbsent) {
    return CancellationNoticesCompanion(
      eventId: Value(eventId),
      participantId: Value(participantId),
      sendStatus: Value(sendStatus),
      sentAt: sentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(sentAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory CancellationNotice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CancellationNotice(
      eventId: serializer.fromJson<int>(json['eventId']),
      participantId: serializer.fromJson<int>(json['participantId']),
      sendStatus: $CancellationNoticesTable.$convertersendStatus.fromJson(
        serializer.fromJson<String>(json['sendStatus']),
      ),
      sentAt: serializer.fromJson<DateTime?>(json['sentAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<int>(eventId),
      'participantId': serializer.toJson<int>(participantId),
      'sendStatus': serializer.toJson<String>(
        $CancellationNoticesTable.$convertersendStatus.toJson(sendStatus),
      ),
      'sentAt': serializer.toJson<DateTime?>(sentAt),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  CancellationNotice copyWith({
    int? eventId,
    int? participantId,
    SendStatus? sendStatus,
    Value<DateTime?> sentAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => CancellationNotice(
    eventId: eventId ?? this.eventId,
    participantId: participantId ?? this.participantId,
    sendStatus: sendStatus ?? this.sendStatus,
    sentAt: sentAt.present ? sentAt.value : this.sentAt,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  CancellationNotice copyWithCompanion(CancellationNoticesCompanion data) {
    return CancellationNotice(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      participantId: data.participantId.present
          ? data.participantId.value
          : this.participantId,
      sendStatus: data.sendStatus.present
          ? data.sendStatus.value
          : this.sendStatus,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CancellationNotice(')
          ..write('eventId: $eventId, ')
          ..write('participantId: $participantId, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('sentAt: $sentAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(eventId, participantId, sendStatus, sentAt, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CancellationNotice &&
          other.eventId == this.eventId &&
          other.participantId == this.participantId &&
          other.sendStatus == this.sendStatus &&
          other.sentAt == this.sentAt &&
          other.lastError == this.lastError);
}

class CancellationNoticesCompanion extends UpdateCompanion<CancellationNotice> {
  final Value<int> eventId;
  final Value<int> participantId;
  final Value<SendStatus> sendStatus;
  final Value<DateTime?> sentAt;
  final Value<String?> lastError;
  const CancellationNoticesCompanion({
    this.eventId = const Value.absent(),
    this.participantId = const Value.absent(),
    this.sendStatus = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  CancellationNoticesCompanion.insert({
    required int eventId,
    this.participantId = const Value.absent(),
    this.sendStatus = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : eventId = Value(eventId);
  static Insertable<CancellationNotice> custom({
    Expression<int>? eventId,
    Expression<int>? participantId,
    Expression<String>? sendStatus,
    Expression<DateTime>? sentAt,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (participantId != null) 'participant_id': participantId,
      if (sendStatus != null) 'send_status': sendStatus,
      if (sentAt != null) 'sent_at': sentAt,
      if (lastError != null) 'last_error': lastError,
    });
  }

  CancellationNoticesCompanion copyWith({
    Value<int>? eventId,
    Value<int>? participantId,
    Value<SendStatus>? sendStatus,
    Value<DateTime?>? sentAt,
    Value<String?>? lastError,
  }) {
    return CancellationNoticesCompanion(
      eventId: eventId ?? this.eventId,
      participantId: participantId ?? this.participantId,
      sendStatus: sendStatus ?? this.sendStatus,
      sentAt: sentAt ?? this.sentAt,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (participantId.present) {
      map['participant_id'] = Variable<int>(participantId.value);
    }
    if (sendStatus.present) {
      map['send_status'] = Variable<String>(
        $CancellationNoticesTable.$convertersendStatus.toSql(sendStatus.value),
      );
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CancellationNoticesCompanion(')
          ..write('eventId: $eventId, ')
          ..write('participantId: $participantId, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('sentAt: $sentAt, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $EmailTemplatesTable emailTemplates = $EmailTemplatesTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $ParticipantsTable participants = $ParticipantsTable(this);
  late final $WishlistItemsTable wishlistItems = $WishlistItemsTable(this);
  late final $AssignmentsTable assignments = $AssignmentsTable(this);
  late final $CancellationNoticesTable cancellationNotices =
      $CancellationNoticesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    emailTemplates,
    events,
    participants,
    wishlistItems,
    assignments,
    cancellationNotices,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'email_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('events', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'email_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('events', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('participants', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'participants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('wishlist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('assignments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'participants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('assignments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'events',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cancellation_notices', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'participants',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cancellation_notices', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$EmailTemplatesTableCreateCompanionBuilder =
    EmailTemplatesCompanion Function({
      Value<int> id,
      required String name,
      required String fileName,
      required TemplateFormat format,
      Value<TemplateKind> kind,
      required String body,
      Value<DateTime> importedAt,
    });
typedef $$EmailTemplatesTableUpdateCompanionBuilder =
    EmailTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> fileName,
      Value<TemplateFormat> format,
      Value<TemplateKind> kind,
      Value<String> body,
      Value<DateTime> importedAt,
    });

final class $$EmailTemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $EmailTemplatesTable, EmailTemplate> {
  $$EmailTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$EventsTable, List<Event>>
  _assignmentTemplateEventsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.events,
        aliasName: 'email_templates__id__events__template_id',
      );

  $$EventsTableProcessedTableManager get assignmentTemplateEvents {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _assignmentTemplateEventsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventsTable, List<Event>>
  _cancellationTemplateEventsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.events,
        aliasName: 'email_templates__id__events__cancel_template_id',
      );

  $$EventsTableProcessedTableManager get cancellationTemplateEvents {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.cancelTemplateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cancellationTemplateEventsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmailTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $EmailTemplatesTable> {
  $$EmailTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TemplateFormat, TemplateFormat, String>
  get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TemplateKind, TemplateKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> assignmentTemplateEvents(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cancellationTemplateEvents(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.cancelTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailTemplatesTable> {
  $$EmailTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailTemplatesTable> {
  $$EmailTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TemplateFormat, String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TemplateKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  Expression<T> assignmentTemplateEvents<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cancellationTemplateEvents<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.cancelTemplateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailTemplatesTable,
          EmailTemplate,
          $$EmailTemplatesTableFilterComposer,
          $$EmailTemplatesTableOrderingComposer,
          $$EmailTemplatesTableAnnotationComposer,
          $$EmailTemplatesTableCreateCompanionBuilder,
          $$EmailTemplatesTableUpdateCompanionBuilder,
          (EmailTemplate, $$EmailTemplatesTableReferences),
          EmailTemplate,
          PrefetchHooks Function({
            bool assignmentTemplateEvents,
            bool cancellationTemplateEvents,
          })
        > {
  $$EmailTemplatesTableTableManager(
    _$AppDatabase db,
    $EmailTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<TemplateFormat> format = const Value.absent(),
                Value<TemplateKind> kind = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
              }) => EmailTemplatesCompanion(
                id: id,
                name: name,
                fileName: fileName,
                format: format,
                kind: kind,
                body: body,
                importedAt: importedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String fileName,
                required TemplateFormat format,
                Value<TemplateKind> kind = const Value.absent(),
                required String body,
                Value<DateTime> importedAt = const Value.absent(),
              }) => EmailTemplatesCompanion.insert(
                id: id,
                name: name,
                fileName: fileName,
                format: format,
                kind: kind,
                body: body,
                importedAt: importedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmailTemplatesTable, EmailTemplate>(table),
                  $$EmailTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                assignmentTemplateEvents = false,
                cancellationTemplateEvents = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (assignmentTemplateEvents) db.events,
                    if (cancellationTemplateEvents) db.events,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (assignmentTemplateEvents)
                        await $_getPrefetchedDataByColumns<
                          EmailTemplate,
                          $EmailTemplatesTable,
                          Event,
                          $EventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EmailTemplatesTableReferences
                              ._assignmentTemplateEventsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmailTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).assignmentTemplateEvents,
                          currentColumn: 'id',
                          referencedColumn: 'template_id',
                          typedResults: items,
                        ),
                      if (cancellationTemplateEvents)
                        await $_getPrefetchedDataByColumns<
                          EmailTemplate,
                          $EmailTemplatesTable,
                          Event,
                          $EventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EmailTemplatesTableReferences
                              ._cancellationTemplateEventsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmailTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).cancellationTemplateEvents,
                          currentColumn: 'id',
                          referencedColumn: 'cancel_template_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmailTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailTemplatesTable,
      EmailTemplate,
      $$EmailTemplatesTableFilterComposer,
      $$EmailTemplatesTableOrderingComposer,
      $$EmailTemplatesTableAnnotationComposer,
      $$EmailTemplatesTableCreateCompanionBuilder,
      $$EmailTemplatesTableUpdateCompanionBuilder,
      (EmailTemplate, $$EmailTemplatesTableReferences),
      EmailTemplate,
      PrefetchHooks Function({
        bool assignmentTemplateEvents,
        bool cancellationTemplateEvents,
      })
    >;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required String name,
  required String slug,
  Value<DateTime?> eventDate,
  Value<String?> eventTime,
  Value<String?> place,
  Value<int?> budgetMinor,
  Value<String> currency,
  Value<String> languageCode,
  Value<int?> templateId,
  Value<String?> emailSubject,
  Value<bool> archived,
  Value<DateTime?> cancelledAt,
  Value<String?> cancelNote,
  Value<int?> cancelTemplateId,
  Value<String?> cancelSubject,
  Value<EventStatus> status,
  Value<DateTime> createdAt,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> slug,
  Value<DateTime?> eventDate,
  Value<String?> eventTime,
  Value<String?> place,
  Value<int?> budgetMinor,
  Value<String> currency,
  Value<String> languageCode,
  Value<int?> templateId,
  Value<String?> emailSubject,
  Value<bool> archived,
  Value<DateTime?> cancelledAt,
  Value<String?> cancelNote,
  Value<int?> cancelTemplateId,
  Value<String?> cancelSubject,
  Value<EventStatus> status,
  Value<DateTime> createdAt,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmailTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.emailTemplates.createAlias('events__template_id__email_templates__id');

  $$EmailTemplatesTableProcessedTableManager? get templateId {
    final $_column = $_itemColumn<int>('template_id');
    if ($_column == null) return null;
    final manager = $$EmailTemplatesTableTableManager(
      $_db,
      $_db.emailTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmailTemplatesTable _cancelTemplateIdTable(_$AppDatabase db) => db
      .emailTemplates
      .createAlias('events__cancel_template_id__email_templates__id');

  $$EmailTemplatesTableProcessedTableManager? get cancelTemplateId {
    final $_column = $_itemColumn<int>('cancel_template_id');
    if ($_column == null) return null;
    final manager = $$EmailTemplatesTableTableManager(
      $_db,
      $_db.emailTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cancelTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ParticipantsTable, List<Participant>>
  _participantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.participants,
    aliasName: 'events__id__participants__event_id',
  );

  $$ParticipantsTableProcessedTableManager get participantsRefs {
    final manager = $$ParticipantsTableTableManager(
      $_db,
      $_db.participants,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_participantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AssignmentsTable, List<Assignment>>
  _assignmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.assignments,
    aliasName: 'events__id__assignments__event_id',
  );

  $$AssignmentsTableProcessedTableManager get assignmentsRefs {
    final manager = $$AssignmentsTableTableManager(
      $_db,
      $_db.assignments,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_assignmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CancellationNoticesTable,
    List<CancellationNotice>
  >
  _cancellationNoticesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cancellationNotices,
        aliasName: 'events__id__cancellation_notices__event_id',
      );

  $$CancellationNoticesTableProcessedTableManager get cancellationNoticesRefs {
    final manager = $$CancellationNoticesTableTableManager(
      $_db,
      $_db.cancellationNotices,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cancellationNoticesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventTime => $composableBuilder(
    column: $table.eventTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetMinor => $composableBuilder(
    column: $table.budgetMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailSubject => $composableBuilder(
    column: $table.emailSubject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelNote => $composableBuilder(
    column: $table.cancelNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelSubject => $composableBuilder(
    column: $table.cancelSubject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EventStatus, EventStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmailTemplatesTableFilterComposer get templateId {
    final $$EmailTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.emailTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.emailTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailTemplatesTableFilterComposer get cancelTemplateId {
    final $$EmailTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cancelTemplateId,
      referencedTable: $db.emailTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.emailTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> participantsRefs(
    Expression<bool> Function($$ParticipantsTableFilterComposer f) f,
  ) {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> assignmentsRefs(
    Expression<bool> Function($$AssignmentsTableFilterComposer f) f,
  ) {
    final $$AssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assignments,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.assignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cancellationNoticesRefs(
    Expression<bool> Function($$CancellationNoticesTableFilterComposer f) f,
  ) {
    final $$CancellationNoticesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cancellationNotices,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CancellationNoticesTableFilterComposer(
            $db: $db,
            $table: $db.cancellationNotices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventTime => $composableBuilder(
    column: $table.eventTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetMinor => $composableBuilder(
    column: $table.budgetMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailSubject => $composableBuilder(
    column: $table.emailSubject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelNote => $composableBuilder(
    column: $table.cancelNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelSubject => $composableBuilder(
    column: $table.cancelSubject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmailTemplatesTableOrderingComposer get templateId {
    final $$EmailTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.emailTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.emailTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailTemplatesTableOrderingComposer get cancelTemplateId {
    final $$EmailTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cancelTemplateId,
      referencedTable: $db.emailTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.emailTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get eventTime =>
      $composableBuilder(column: $table.eventTime, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<int> get budgetMinor => $composableBuilder(
    column: $table.budgetMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emailSubject => $composableBuilder(
    column: $table.emailSubject,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelNote => $composableBuilder(
    column: $table.cancelNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelSubject => $composableBuilder(
    column: $table.cancelSubject,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<EventStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EmailTemplatesTableAnnotationComposer get templateId {
    final $$EmailTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.emailTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.emailTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmailTemplatesTableAnnotationComposer get cancelTemplateId {
    final $$EmailTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cancelTemplateId,
      referencedTable: $db.emailTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.emailTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> participantsRefs<T extends Object>(
    Expression<T> Function($$ParticipantsTableAnnotationComposer a) f,
  ) {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableAnnotationComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> assignmentsRefs<T extends Object>(
    Expression<T> Function($$AssignmentsTableAnnotationComposer a) f,
  ) {
    final $$AssignmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assignments,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssignmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.assignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cancellationNoticesRefs<T extends Object>(
    Expression<T> Function($$CancellationNoticesTableAnnotationComposer a) f,
  ) {
    final $$CancellationNoticesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cancellationNotices,
          getReferencedColumn: (t) => t.eventId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CancellationNoticesTableAnnotationComposer(
                $db: $db,
                $table: $db.cancellationNotices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, $$EventsTableReferences),
          Event,
          PrefetchHooks Function({
            bool templateId,
            bool cancelTemplateId,
            bool participantsRefs,
            bool assignmentsRefs,
            bool cancellationNoticesRefs,
          })
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<DateTime?> eventDate = const Value.absent(),
                Value<String?> eventTime = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<int?> budgetMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                Value<String?> emailSubject = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelNote = const Value.absent(),
                Value<int?> cancelTemplateId = const Value.absent(),
                Value<String?> cancelSubject = const Value.absent(),
                Value<EventStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                name: name,
                slug: slug,
                eventDate: eventDate,
                eventTime: eventTime,
                place: place,
                budgetMinor: budgetMinor,
                currency: currency,
                languageCode: languageCode,
                templateId: templateId,
                emailSubject: emailSubject,
                archived: archived,
                cancelledAt: cancelledAt,
                cancelNote: cancelNote,
                cancelTemplateId: cancelTemplateId,
                cancelSubject: cancelSubject,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String slug,
                Value<DateTime?> eventDate = const Value.absent(),
                Value<String?> eventTime = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<int?> budgetMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                Value<String?> emailSubject = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<String?> cancelNote = const Value.absent(),
                Value<int?> cancelTemplateId = const Value.absent(),
                Value<String?> cancelSubject = const Value.absent(),
                Value<EventStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                name: name,
                slug: slug,
                eventDate: eventDate,
                eventTime: eventTime,
                place: place,
                budgetMinor: budgetMinor,
                currency: currency,
                languageCode: languageCode,
                templateId: templateId,
                emailSubject: emailSubject,
                archived: archived,
                cancelledAt: cancelledAt,
                cancelNote: cancelNote,
                cancelTemplateId: cancelTemplateId,
                cancelSubject: cancelSubject,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EventsTable, Event>(table),
                  $$EventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                templateId = false,
                cancelTemplateId = false,
                participantsRefs = false,
                assignmentsRefs = false,
                cancellationNoticesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (participantsRefs) db.participants,
                    if (assignmentsRefs) db.assignments,
                    if (cancellationNoticesRefs) db.cancellationNotices,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (templateId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.templateId,
                            referencedTable: $$EventsTableReferences
                                ._templateIdTable(db),
                            referencedColumn: $$EventsTableReferences
                                ._templateIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (cancelTemplateId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cancelTemplateId,
                            referencedTable: $$EventsTableReferences
                                ._cancelTemplateIdTable(db),
                            referencedColumn: $$EventsTableReferences
                                ._cancelTemplateIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (participantsRefs)
                        await $_getPrefetchedDataByColumns<
                          Event,
                          $EventsTable,
                          Participant,
                          $ParticipantsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._participantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).participantsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                      if (assignmentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Event,
                          $EventsTable,
                          Assignment,
                          $AssignmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._assignmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).assignmentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                      if (cancellationNoticesRefs)
                        await $_getPrefetchedDataByColumns<
                          Event,
                          $EventsTable,
                          CancellationNotice,
                          $CancellationNoticesTable
                        >(
                          currentTable: table,
                          referencedTable: $$EventsTableReferences
                              ._cancellationNoticesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).cancellationNoticesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'event_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, $$EventsTableReferences),
      Event,
      PrefetchHooks Function({
        bool templateId,
        bool cancelTemplateId,
        bool participantsRefs,
        bool assignmentsRefs,
        bool cancellationNoticesRefs,
      })
    >;
typedef $$ParticipantsTableCreateCompanionBuilder =
    ParticipantsCompanion Function({
      Value<int> id,
      required int eventId,
      required String name,
      required String email,
      Value<String?> groupTag,
    });
typedef $$ParticipantsTableUpdateCompanionBuilder =
    ParticipantsCompanion Function({
      Value<int> id,
      Value<int> eventId,
      Value<String> name,
      Value<String> email,
      Value<String?> groupTag,
    });

final class $$ParticipantsTableReferences
    extends BaseReferences<_$AppDatabase, $ParticipantsTable, Participant> {
  $$ParticipantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('participants__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WishlistItemsTable, List<WishlistItem>>
  _wishlistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wishlistItems,
    aliasName: 'participants__id__wishlist_items__participant_id',
  );

  $$WishlistItemsTableProcessedTableManager get wishlistItemsRefs {
    final manager = $$WishlistItemsTableTableManager(
      $_db,
      $_db.wishlistItems,
    ).filter((f) => f.participantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wishlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AssignmentsTable, List<Assignment>>
  _givingAssignmentsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.assignments,
    aliasName: 'participants__id__assignments__giver_id',
  );

  $$AssignmentsTableProcessedTableManager get givingAssignments {
    final manager = $$AssignmentsTableTableManager(
      $_db,
      $_db.assignments,
    ).filter((f) => f.giverId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_givingAssignmentsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AssignmentsTable, List<Assignment>>
  _receivingAssignmentsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.assignments,
    aliasName: 'participants__id__assignments__recipient_id',
  );

  $$AssignmentsTableProcessedTableManager get receivingAssignments {
    final manager = $$AssignmentsTableTableManager(
      $_db,
      $_db.assignments,
    ).filter((f) => f.recipientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _receivingAssignmentsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CancellationNoticesTable,
    List<CancellationNotice>
  >
  _cancellationNoticesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cancellationNotices,
        aliasName: 'participants__id__cancellation_notices__participant_id',
      );

  $$CancellationNoticesTableProcessedTableManager get cancellationNoticesRefs {
    final manager = $$CancellationNoticesTableTableManager(
      $_db,
      $_db.cancellationNotices,
    ).filter((f) => f.participantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cancellationNoticesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ParticipantsTableFilterComposer
    extends Composer<_$AppDatabase, $ParticipantsTable> {
  $$ParticipantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupTag => $composableBuilder(
    column: $table.groupTag,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> wishlistItemsRefs(
    Expression<bool> Function($$WishlistItemsTableFilterComposer f) f,
  ) {
    final $$WishlistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishlistItems,
      getReferencedColumn: (t) => t.participantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishlistItemsTableFilterComposer(
            $db: $db,
            $table: $db.wishlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> givingAssignments(
    Expression<bool> Function($$AssignmentsTableFilterComposer f) f,
  ) {
    final $$AssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assignments,
      getReferencedColumn: (t) => t.giverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.assignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> receivingAssignments(
    Expression<bool> Function($$AssignmentsTableFilterComposer f) f,
  ) {
    final $$AssignmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assignments,
      getReferencedColumn: (t) => t.recipientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssignmentsTableFilterComposer(
            $db: $db,
            $table: $db.assignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cancellationNoticesRefs(
    Expression<bool> Function($$CancellationNoticesTableFilterComposer f) f,
  ) {
    final $$CancellationNoticesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cancellationNotices,
      getReferencedColumn: (t) => t.participantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CancellationNoticesTableFilterComposer(
            $db: $db,
            $table: $db.cancellationNotices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ParticipantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParticipantsTable> {
  $$ParticipantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupTag => $composableBuilder(
    column: $table.groupTag,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParticipantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParticipantsTable> {
  $$ParticipantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get groupTag =>
      $composableBuilder(column: $table.groupTag, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> wishlistItemsRefs<T extends Object>(
    Expression<T> Function($$WishlistItemsTableAnnotationComposer a) f,
  ) {
    final $$WishlistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wishlistItems,
      getReferencedColumn: (t) => t.participantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WishlistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.wishlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> givingAssignments<T extends Object>(
    Expression<T> Function($$AssignmentsTableAnnotationComposer a) f,
  ) {
    final $$AssignmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assignments,
      getReferencedColumn: (t) => t.giverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssignmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.assignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> receivingAssignments<T extends Object>(
    Expression<T> Function($$AssignmentsTableAnnotationComposer a) f,
  ) {
    final $$AssignmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.assignments,
      getReferencedColumn: (t) => t.recipientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AssignmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.assignments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cancellationNoticesRefs<T extends Object>(
    Expression<T> Function($$CancellationNoticesTableAnnotationComposer a) f,
  ) {
    final $$CancellationNoticesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cancellationNotices,
          getReferencedColumn: (t) => t.participantId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CancellationNoticesTableAnnotationComposer(
                $db: $db,
                $table: $db.cancellationNotices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ParticipantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParticipantsTable,
          Participant,
          $$ParticipantsTableFilterComposer,
          $$ParticipantsTableOrderingComposer,
          $$ParticipantsTableAnnotationComposer,
          $$ParticipantsTableCreateCompanionBuilder,
          $$ParticipantsTableUpdateCompanionBuilder,
          (Participant, $$ParticipantsTableReferences),
          Participant,
          PrefetchHooks Function({
            bool eventId,
            bool wishlistItemsRefs,
            bool givingAssignments,
            bool receivingAssignments,
            bool cancellationNoticesRefs,
          })
        > {
  $$ParticipantsTableTableManager(_$AppDatabase db, $ParticipantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParticipantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParticipantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParticipantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> eventId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> groupTag = const Value.absent(),
              }) => ParticipantsCompanion(
                id: id,
                eventId: eventId,
                name: name,
                email: email,
                groupTag: groupTag,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int eventId,
                required String name,
                required String email,
                Value<String?> groupTag = const Value.absent(),
              }) => ParticipantsCompanion.insert(
                id: id,
                eventId: eventId,
                name: name,
                email: email,
                groupTag: groupTag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ParticipantsTable, Participant>(table),
                  $$ParticipantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                eventId = false,
                wishlistItemsRefs = false,
                givingAssignments = false,
                receivingAssignments = false,
                cancellationNoticesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (wishlistItemsRefs) db.wishlistItems,
                    if (givingAssignments) db.assignments,
                    if (receivingAssignments) db.assignments,
                    if (cancellationNoticesRefs) db.cancellationNotices,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (eventId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$ParticipantsTableReferences
                                ._eventIdTable(db),
                            referencedColumn: $$ParticipantsTableReferences
                                ._eventIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (wishlistItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Participant,
                          $ParticipantsTable,
                          WishlistItem,
                          $WishlistItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ParticipantsTableReferences
                              ._wishlistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ParticipantsTableReferences(
                                db,
                                table,
                                p0,
                              ).wishlistItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'participant_id',
                          typedResults: items,
                        ),
                      if (givingAssignments)
                        await $_getPrefetchedDataByColumns<
                          Participant,
                          $ParticipantsTable,
                          Assignment,
                          $AssignmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ParticipantsTableReferences
                              ._givingAssignmentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ParticipantsTableReferences(
                                db,
                                table,
                                p0,
                              ).givingAssignments,
                          currentColumn: 'id',
                          referencedColumn: 'giver_id',
                          typedResults: items,
                        ),
                      if (receivingAssignments)
                        await $_getPrefetchedDataByColumns<
                          Participant,
                          $ParticipantsTable,
                          Assignment,
                          $AssignmentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ParticipantsTableReferences
                              ._receivingAssignmentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ParticipantsTableReferences(
                                db,
                                table,
                                p0,
                              ).receivingAssignments,
                          currentColumn: 'id',
                          referencedColumn: 'recipient_id',
                          typedResults: items,
                        ),
                      if (cancellationNoticesRefs)
                        await $_getPrefetchedDataByColumns<
                          Participant,
                          $ParticipantsTable,
                          CancellationNotice,
                          $CancellationNoticesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ParticipantsTableReferences
                              ._cancellationNoticesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ParticipantsTableReferences(
                                db,
                                table,
                                p0,
                              ).cancellationNoticesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'participant_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ParticipantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParticipantsTable,
      Participant,
      $$ParticipantsTableFilterComposer,
      $$ParticipantsTableOrderingComposer,
      $$ParticipantsTableAnnotationComposer,
      $$ParticipantsTableCreateCompanionBuilder,
      $$ParticipantsTableUpdateCompanionBuilder,
      (Participant, $$ParticipantsTableReferences),
      Participant,
      PrefetchHooks Function({
        bool eventId,
        bool wishlistItemsRefs,
        bool givingAssignments,
        bool receivingAssignments,
        bool cancellationNoticesRefs,
      })
    >;
typedef $$WishlistItemsTableCreateCompanionBuilder =
    WishlistItemsCompanion Function({
      Value<int> id,
      required int participantId,
      required int position,
      required String itemText,
      Value<String?> url,
    });
typedef $$WishlistItemsTableUpdateCompanionBuilder =
    WishlistItemsCompanion Function({
      Value<int> id,
      Value<int> participantId,
      Value<int> position,
      Value<String> itemText,
      Value<String?> url,
    });

final class $$WishlistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $WishlistItemsTable, WishlistItem> {
  $$WishlistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ParticipantsTable _participantIdTable(_$AppDatabase db) => db
      .participants
      .createAlias('wishlist_items__participant_id__participants__id');

  $$ParticipantsTableProcessedTableManager get participantId {
    final $_column = $_itemColumn<int>('participant_id')!;

    final manager = $$ParticipantsTableTableManager(
      $_db,
      $_db.participants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_participantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WishlistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemText => $composableBuilder(
    column: $table.itemText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  $$ParticipantsTableFilterComposer get participantId {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemText => $composableBuilder(
    column: $table.itemText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  $$ParticipantsTableOrderingComposer get participantId {
    final $$ParticipantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableOrderingComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WishlistItemsTable> {
  $$WishlistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get itemText =>
      $composableBuilder(column: $table.itemText, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  $$ParticipantsTableAnnotationComposer get participantId {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableAnnotationComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WishlistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WishlistItemsTable,
          WishlistItem,
          $$WishlistItemsTableFilterComposer,
          $$WishlistItemsTableOrderingComposer,
          $$WishlistItemsTableAnnotationComposer,
          $$WishlistItemsTableCreateCompanionBuilder,
          $$WishlistItemsTableUpdateCompanionBuilder,
          (WishlistItem, $$WishlistItemsTableReferences),
          WishlistItem,
          PrefetchHooks Function({bool participantId})
        > {
  $$WishlistItemsTableTableManager(_$AppDatabase db, $WishlistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WishlistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WishlistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WishlistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> participantId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> itemText = const Value.absent(),
                Value<String?> url = const Value.absent(),
              }) => WishlistItemsCompanion(
                id: id,
                participantId: participantId,
                position: position,
                itemText: itemText,
                url: url,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int participantId,
                required int position,
                required String itemText,
                Value<String?> url = const Value.absent(),
              }) => WishlistItemsCompanion.insert(
                id: id,
                participantId: participantId,
                position: position,
                itemText: itemText,
                url: url,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WishlistItemsTable, WishlistItem>(table),
                  $$WishlistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({participantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (participantId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.participantId,
                        referencedTable: $$WishlistItemsTableReferences
                            ._participantIdTable(db),
                        referencedColumn: $$WishlistItemsTableReferences
                            ._participantIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WishlistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WishlistItemsTable,
      WishlistItem,
      $$WishlistItemsTableFilterComposer,
      $$WishlistItemsTableOrderingComposer,
      $$WishlistItemsTableAnnotationComposer,
      $$WishlistItemsTableCreateCompanionBuilder,
      $$WishlistItemsTableUpdateCompanionBuilder,
      (WishlistItem, $$WishlistItemsTableReferences),
      WishlistItem,
      PrefetchHooks Function({bool participantId})
    >;
typedef $$AssignmentsTableCreateCompanionBuilder =
    AssignmentsCompanion Function({
      required int eventId,
      required int giverId,
      required int recipientId,
      Value<SendStatus> sendStatus,
      Value<DateTime?> sentAt,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$AssignmentsTableUpdateCompanionBuilder =
    AssignmentsCompanion Function({
      Value<int> eventId,
      Value<int> giverId,
      Value<int> recipientId,
      Value<SendStatus> sendStatus,
      Value<DateTime?> sentAt,
      Value<String?> lastError,
      Value<int> rowid,
    });

final class $$AssignmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AssignmentsTable, Assignment> {
  $$AssignmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('assignments__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ParticipantsTable _giverIdTable(_$AppDatabase db) =>
      db.participants.createAlias('assignments__giver_id__participants__id');

  $$ParticipantsTableProcessedTableManager get giverId {
    final $_column = $_itemColumn<int>('giver_id')!;

    final manager = $$ParticipantsTableTableManager(
      $_db,
      $_db.participants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_giverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ParticipantsTable _recipientIdTable(_$AppDatabase db) => db
      .participants
      .createAlias('assignments__recipient_id__participants__id');

  $$ParticipantsTableProcessedTableManager get recipientId {
    final $_column = $_itemColumn<int>('recipient_id')!;

    final manager = $$ParticipantsTableTableManager(
      $_db,
      $_db.participants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AssignmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AssignmentsTable> {
  $$AssignmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<SendStatus, SendStatus, String>
  get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableFilterComposer get giverId {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.giverId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableFilterComposer get recipientId {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipientId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssignmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssignmentsTable> {
  $$AssignmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableOrderingComposer get giverId {
    final $$ParticipantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.giverId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableOrderingComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableOrderingComposer get recipientId {
    final $$ParticipantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipientId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableOrderingComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssignmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssignmentsTable> {
  $$AssignmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<SendStatus, String> get sendStatus =>
      $composableBuilder(
        column: $table.sendStatus,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableAnnotationComposer get giverId {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.giverId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableAnnotationComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableAnnotationComposer get recipientId {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipientId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableAnnotationComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AssignmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssignmentsTable,
          Assignment,
          $$AssignmentsTableFilterComposer,
          $$AssignmentsTableOrderingComposer,
          $$AssignmentsTableAnnotationComposer,
          $$AssignmentsTableCreateCompanionBuilder,
          $$AssignmentsTableUpdateCompanionBuilder,
          (Assignment, $$AssignmentsTableReferences),
          Assignment,
          PrefetchHooks Function({bool eventId, bool giverId, bool recipientId})
        > {
  $$AssignmentsTableTableManager(_$AppDatabase db, $AssignmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssignmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssignmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssignmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> eventId = const Value.absent(),
                Value<int> giverId = const Value.absent(),
                Value<int> recipientId = const Value.absent(),
                Value<SendStatus> sendStatus = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssignmentsCompanion(
                eventId: eventId,
                giverId: giverId,
                recipientId: recipientId,
                sendStatus: sendStatus,
                sentAt: sentAt,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int eventId,
                required int giverId,
                required int recipientId,
                Value<SendStatus> sendStatus = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssignmentsCompanion.insert(
                eventId: eventId,
                giverId: giverId,
                recipientId: recipientId,
                sendStatus: sendStatus,
                sentAt: sentAt,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AssignmentsTable, Assignment>(table),
                  $$AssignmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({eventId = false, giverId = false, recipientId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (eventId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$AssignmentsTableReferences
                                ._eventIdTable(db),
                            referencedColumn: $$AssignmentsTableReferences
                                ._eventIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (giverId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.giverId,
                            referencedTable: $$AssignmentsTableReferences
                                ._giverIdTable(db),
                            referencedColumn: $$AssignmentsTableReferences
                                ._giverIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (recipientId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.recipientId,
                            referencedTable: $$AssignmentsTableReferences
                                ._recipientIdTable(db),
                            referencedColumn: $$AssignmentsTableReferences
                                ._recipientIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AssignmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssignmentsTable,
      Assignment,
      $$AssignmentsTableFilterComposer,
      $$AssignmentsTableOrderingComposer,
      $$AssignmentsTableAnnotationComposer,
      $$AssignmentsTableCreateCompanionBuilder,
      $$AssignmentsTableUpdateCompanionBuilder,
      (Assignment, $$AssignmentsTableReferences),
      Assignment,
      PrefetchHooks Function({bool eventId, bool giverId, bool recipientId})
    >;
typedef $$CancellationNoticesTableCreateCompanionBuilder =
    CancellationNoticesCompanion Function({
      required int eventId,
      Value<int> participantId,
      Value<SendStatus> sendStatus,
      Value<DateTime?> sentAt,
      Value<String?> lastError,
    });
typedef $$CancellationNoticesTableUpdateCompanionBuilder =
    CancellationNoticesCompanion Function({
      Value<int> eventId,
      Value<int> participantId,
      Value<SendStatus> sendStatus,
      Value<DateTime?> sentAt,
      Value<String?> lastError,
    });

final class $$CancellationNoticesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CancellationNoticesTable,
          CancellationNotice
        > {
  $$CancellationNoticesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EventsTable _eventIdTable(_$AppDatabase db) =>
      db.events.createAlias('cancellation_notices__event_id__events__id');

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ParticipantsTable _participantIdTable(_$AppDatabase db) => db
      .participants
      .createAlias('cancellation_notices__participant_id__participants__id');

  $$ParticipantsTableProcessedTableManager get participantId {
    final $_column = $_itemColumn<int>('participant_id')!;

    final manager = $$ParticipantsTableTableManager(
      $_db,
      $_db.participants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_participantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CancellationNoticesTableFilterComposer
    extends Composer<_$AppDatabase, $CancellationNoticesTable> {
  $$CancellationNoticesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<SendStatus, SendStatus, String>
  get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableFilterComposer get participantId {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableFilterComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CancellationNoticesTableOrderingComposer
    extends Composer<_$AppDatabase, $CancellationNoticesTable> {
  $$CancellationNoticesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sendStatus => $composableBuilder(
    column: $table.sendStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableOrderingComposer get participantId {
    final $$ParticipantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableOrderingComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CancellationNoticesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CancellationNoticesTable> {
  $$CancellationNoticesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<SendStatus, String> get sendStatus =>
      $composableBuilder(
        column: $table.sendStatus,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ParticipantsTableAnnotationComposer get participantId {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.participantId,
      referencedTable: $db.participants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParticipantsTableAnnotationComposer(
            $db: $db,
            $table: $db.participants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CancellationNoticesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CancellationNoticesTable,
          CancellationNotice,
          $$CancellationNoticesTableFilterComposer,
          $$CancellationNoticesTableOrderingComposer,
          $$CancellationNoticesTableAnnotationComposer,
          $$CancellationNoticesTableCreateCompanionBuilder,
          $$CancellationNoticesTableUpdateCompanionBuilder,
          (CancellationNotice, $$CancellationNoticesTableReferences),
          CancellationNotice,
          PrefetchHooks Function({bool eventId, bool participantId})
        > {
  $$CancellationNoticesTableTableManager(
    _$AppDatabase db,
    $CancellationNoticesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CancellationNoticesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CancellationNoticesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CancellationNoticesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> eventId = const Value.absent(),
                Value<int> participantId = const Value.absent(),
                Value<SendStatus> sendStatus = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => CancellationNoticesCompanion(
                eventId: eventId,
                participantId: participantId,
                sendStatus: sendStatus,
                sentAt: sentAt,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                required int eventId,
                Value<int> participantId = const Value.absent(),
                Value<SendStatus> sendStatus = const Value.absent(),
                Value<DateTime?> sentAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => CancellationNoticesCompanion.insert(
                eventId: eventId,
                participantId: participantId,
                sendStatus: sendStatus,
                sentAt: sentAt,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CancellationNoticesTable, CancellationNotice>(
                    table,
                  ),
                  $$CancellationNoticesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false, participantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$CancellationNoticesTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$CancellationNoticesTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (participantId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.participantId,
                        referencedTable: $$CancellationNoticesTableReferences
                            ._participantIdTable(db),
                        referencedColumn: $$CancellationNoticesTableReferences
                            ._participantIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CancellationNoticesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CancellationNoticesTable,
      CancellationNotice,
      $$CancellationNoticesTableFilterComposer,
      $$CancellationNoticesTableOrderingComposer,
      $$CancellationNoticesTableAnnotationComposer,
      $$CancellationNoticesTableCreateCompanionBuilder,
      $$CancellationNoticesTableUpdateCompanionBuilder,
      (CancellationNotice, $$CancellationNoticesTableReferences),
      CancellationNotice,
      PrefetchHooks Function({bool eventId, bool participantId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$EmailTemplatesTableTableManager get emailTemplates =>
      $$EmailTemplatesTableTableManager(_db, _db.emailTemplates);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$ParticipantsTableTableManager get participants =>
      $$ParticipantsTableTableManager(_db, _db.participants);
  $$WishlistItemsTableTableManager get wishlistItems =>
      $$WishlistItemsTableTableManager(_db, _db.wishlistItems);
  $$AssignmentsTableTableManager get assignments =>
      $$AssignmentsTableTableManager(_db, _db.assignments);
  $$CancellationNoticesTableTableManager get cancellationNotices =>
      $$CancellationNoticesTableTableManager(_db, _db.cancellationNotices);
}
