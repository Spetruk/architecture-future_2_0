# Доменные события (Domain Events)

## Общие принципы

Все доменные события следуют единой структуре:
- **EventId**: Уникальный идентификатор события
- **EventType**: Тип события
- **AggregateId**: Идентификатор агрегата-источника
- **AggregateType**: Тип агрегата-источника
- **Timestamp**: Временная метка события
- **Version**: Версия агрегата
- **Data**: Полезная нагрузка события
- **Metadata**: Метаданные (источник, корреляция и т.д.)

## 1. Медицинский домен (Patient Care Context)

### PatientRegistered
**Источник:** Patient Aggregate
**Описание:** Пациент зарегистрирован в системе
**Полезная нагрузка:**
```json
{
  "patientId": "uuid",
  "personalInfo": {
    "firstName": "string",
    "lastName": "string",
    "dateOfBirth": "date",
    "gender": "enum"
  },
  "contactInfo": {
    "phone": "string",
    "email": "string",
    "address": "object"
  },
  "registrationDate": "datetime"
}
```
**Подписчики:** 
- Fintech Domain (создание счёта)
- Data Platform (аналитика)

### AppointmentScheduled
**Источник:** Appointment Aggregate
**Описание:** Запись на приём создана
**Полезная нагрузка:**
```json
{
  "appointmentId": "uuid",
  "patientId": "uuid",
  "doctorId": "uuid",
  "appointmentDate": "datetime",
  "duration": "integer",
  "appointmentType": "enum",
  "clinicId": "uuid"
}
```
**Подписчики:**
- Equipment Domain (резервирование оборудования)
- AI Domain (подготовка данных для анализа)
- Data Platform (аналитика)

### TreatmentStarted
**Источник:** Treatment Aggregate
**Описание:** Лечение начато
**Полезная нагрузка:**
```json
{
  "treatmentId": "uuid",
  "patientId": "uuid",
  "doctorId": "uuid",
  "diagnosis": "string",
  "treatmentPlan": "object",
  "startDate": "datetime",
  "estimatedDuration": "integer"
}
```
**Подписчики:**
- Pharma Domain (создание рецептов)
- Equipment Domain (использование оборудования)
- Fintech Domain (создание счёта)
- AI Domain (анализ лечения)

### PrescriptionCreated
**Источник:** Treatment Aggregate
**Описание:** Рецепт создан врачом
**Полезная нагрузка:**
```json
{
  "prescriptionId": "uuid",
  "treatmentId": "uuid",
  "patientId": "uuid",
  "doctorId": "uuid",
  "medications": [
    {
      "drugId": "uuid",
      "dosage": "string",
      "frequency": "string",
      "duration": "integer"
    }
  ],
  "createdDate": "datetime",
  "validUntil": "date"
}
```
**Подписчики:**
- Pharma Domain (обработка рецепта)
- AI Domain (проверка взаимодействий)

### MedicalRecordUpdated
**Источник:** MedicalRecord Aggregate
**Описание:** Медкарта обновлена
**Полезная нагрузка:**
```json
{
  "recordId": "uuid",
  "patientId": "uuid",
  "doctorId": "uuid",
  "updateType": "enum",
  "changes": "object",
  "updateDate": "datetime",
  "version": "integer"
}
```
**Подписчики:**
- AI Domain (обновление данных для ML)
- Data Platform (синхронизация данных)

## 2. Финтех домен (Financial Services Context)

### AccountCreated
**Источник:** Account Aggregate
**Описание:** Банковский счёт создан
**Полезная нагрузка:**
```json
{
  "accountId": "uuid",
  "customerId": "uuid",
  "accountType": "enum",
  "currency": "string",
  "initialBalance": "decimal",
  "createdDate": "datetime",
  "status": "enum"
}
```
**Подписчики:**
- Medical Domain (связывание с пациентом)
- Data Platform (финансовая аналитика)

### PaymentProcessed
**Источник:** Payment Aggregate
**Описание:** Платёж обработан
**Полезная нагрузка:**
```json
{
  "paymentId": "uuid",
  "accountId": "uuid",
  "amount": "decimal",
  "currency": "string",
  "recipient": "object",
  "paymentMethod": "enum",
  "status": "enum",
  "processedDate": "datetime",
  "reference": "string"
}
```
**Подписчики:**
- Medical Domain (подтверждение оплаты услуг)
- Pharma Domain (подтверждение оплаты лекарств)
- Data Platform (финансовая аналитика)

### CreditApproved
**Источник:** Credit Aggregate
**Описание:** Кредит одобрен
**Полезная нагрузка:**
```json
{
  "creditId": "uuid",
  "customerId": "uuid",
  "amount": "decimal",
  "interestRate": "decimal",
  "term": "integer",
  "approvedDate": "datetime",
  "approvedBy": "uuid",
  "conditions": "object"
}
```
**Подписчики:**
- Medical Domain (уведомление о доступности кредита)
- Data Platform (кредитная аналитика)

### TransactionCompleted
**Источник:** Account Aggregate
**Описание:** Транзакция завершена
**Полезная нагрузка:**
```json
{
  "transactionId": "uuid",
  "accountId": "uuid",
  "amount": "decimal",
  "transactionType": "enum",
  "description": "string",
  "balance": "decimal",
  "completedDate": "datetime"
}
```
**Подписчики:**
- Data Platform (транзакционная аналитика)

## 3. AI-сервисы домен (Intelligent Diagnostics Context)

### ModelTrained
**Источник:** Model Aggregate
**Описание:** ML модель обучена
**Полезная нагрузка:**
```json
{
  "modelId": "uuid",
  "modelType": "enum",
  "version": "string",
  "trainingDataSize": "integer",
  "metrics": {
    "accuracy": "decimal",
    "precision": "decimal",
    "recall": "decimal",
    "f1Score": "decimal"
  },
  "trainingDate": "datetime",
  "trainingDuration": "integer"
}
```
**Подписчики:**
- Data Platform (регистрация модели)
- Medical Domain (уведомление о готовности)

### PredictionGenerated
**Источник:** Prediction Aggregate
**Описание:** Предсказание сгенерировано
**Полезная нагрузка:**
```json
{
  "predictionId": "uuid",
  "modelId": "uuid",
  "patientId": "uuid",
  "inputData": "object",
  "prediction": "object",
  "confidence": "decimal",
  "generatedDate": "datetime",
  "explanation": "object"
}
```
**Подписчики:**
- Medical Domain (результаты анализа)
- Data Platform (метрики использования)

### DiagnosisCompleted
**Источник:** Diagnosis Aggregate
**Описание:** AI диагноз завершён
**Полезная нагрузка:**
```json
{
  "diagnosisId": "uuid",
  "patientId": "uuid",
  "modelId": "uuid",
  "condition": "string",
  "confidence": "decimal",
  "evidence": "array",
  "recommendations": "array",
  "completedDate": "datetime"
}
```
**Подписчики:**
- Medical Domain (результаты диагностики)
- Pharma Domain (рекомендации по лекарствам)

### ModelDriftDetected
**Источник:** Model Aggregate
**Описание:** Обнаружен дрифт модели
**Полезная нагрузка:**
```json
{
  "modelId": "uuid",
  "driftType": "enum",
  "driftScore": "decimal",
  "affectedFeatures": "array",
  "detectedDate": "datetime",
  "recommendation": "string"
}
```
**Подписчики:**
- Data Platform (мониторинг качества)
- Medical Domain (уведомление о необходимости переобучения)

## 4. Фармацевтический домен (Pharmaceutical Management Context)

### DrugAdded
**Источник:** Drug Aggregate
**Описание:** Лекарство добавлено в каталог
**Полезная нагрузка:**
```json
{
  "drugId": "uuid",
  "drugName": "string",
  "activeSubstance": "string",
  "dosageForm": "enum",
  "strength": "string",
  "manufacturer": "string",
  "addedDate": "datetime",
  "interactions": "array"
}
```
**Подписчики:**
- AI Domain (обновление базы взаимодействий)
- Data Platform (каталог лекарств)

### InventoryUpdated
**Источник:** Inventory Aggregate
**Описание:** Запас обновлён
**Полезная нагрузка:**
```json
{
  "inventoryId": "uuid",
  "drugId": "uuid",
  "pharmacyId": "uuid",
  "quantity": "integer",
  "expiryDate": "date",
  "batchNumber": "string",
  "updatedDate": "datetime",
  "updateType": "enum"
}
```
**Подписчики:**
- Medical Domain (доступность лекарств)
- Data Platform (аналитика запасов)

### PrescriptionFilled
**Источник:** Prescription Aggregate
**Описание:** Рецепт выполнен
**Полезная нагрузка:**
```json
{
  "prescriptionId": "uuid",
  "patientId": "uuid",
  "pharmacyId": "uuid",
  "medications": "array",
  "filledDate": "datetime",
  "pharmacistId": "uuid",
  "totalAmount": "decimal"
}
```
**Подписчики:**
- Medical Domain (подтверждение выполнения)
- Fintech Domain (создание счёта)
- Data Platform (аналитика продаж)

### StockLow
**Источник:** Inventory Aggregate
**Описание:** Запас лекарства низкий
**Полезная нагрузка:**
```json
{
  "inventoryId": "uuid",
  "drugId": "uuid",
  "pharmacyId": "uuid",
  "currentQuantity": "integer",
  "minimumQuantity": "integer",
  "alertDate": "datetime",
  "urgency": "enum"
}
```
**Подписчики:**
- Procurement Service (автоматический заказ)
- Data Platform (аналитика запасов)

## 5. Оборудование домен (Medical Equipment Context)

### EquipmentRegistered
**Источник:** Equipment Aggregate
**Описание:** Оборудование зарегистрировано
**Полезная нагрузка:**
```json
{
  "equipmentId": "uuid",
  "serialNumber": "string",
  "equipmentType": "enum",
  "manufacturer": "string",
  "model": "string",
  "location": "object",
  "registeredDate": "datetime",
  "status": "enum"
}
```
**Подписчики:**
- Medical Domain (доступность оборудования)
- Data Platform (регистр оборудования)

### MaintenanceScheduled
**Источник:** Maintenance Aggregate
**Описание:** Обслуживание запланировано
**Полезная нагрузка:**
```json
{
  "maintenanceId": "uuid",
  "equipmentId": "uuid",
  "maintenanceType": "enum",
  "scheduledDate": "datetime",
  "estimatedDuration": "integer",
  "technicianId": "uuid",
  "priority": "enum"
}
```
**Подписчики:**
- Medical Domain (планирование использования)
- Data Platform (планирование обслуживания)

### AnomalyDetected
**Источник:** Telemetry Aggregate
**Описание:** Обнаружена аномалия в работе оборудования
**Полезная нагрузка:**
```json
{
  "anomalyId": "uuid",
  "equipmentId": "uuid",
  "anomalyType": "enum",
  "severity": "enum",
  "detectedMetrics": "object",
  "detectedDate": "datetime",
  "recommendation": "string"
}
```
**Подписчики:**
- Maintenance Service (планирование ремонта)
- Medical Domain (уведомление о недоступности)
- Data Platform (аналитика отказов)

### EquipmentFailure
**Источник:** Incident Aggregate
**Описание:** Отказ оборудования
**Полезная нагрузка:**
```json
{
  "incidentId": "uuid",
  "equipmentId": "uuid",
  "failureType": "enum",
  "severity": "enum",
  "description": "string",
  "reportedDate": "datetime",
  "reportedBy": "uuid",
  "impact": "object"
}
```
**Подписчики:**
- Medical Domain (уведомление о недоступности)
- Maintenance Service (экстренный ремонт)
- Data Platform (аналитика отказов)

## 6. Платформа данных (Data Platform Context)

### DataProductCreated
**Источник:** DataProduct Aggregate
**Описание:** Продукт данных создан
**Полезная нагрузка:**
```json
{
  "dataProductId": "uuid",
  "productName": "string",
  "domain": "enum",
  "owner": "uuid",
  "description": "string",
  "schema": "object",
  "sla": "object",
  "createdDate": "datetime"
}
```
**Подписчики:**
- Portal Domain (доступность для аналитики)
- Data Catalog (регистрация метаданных)

### EventPublished
**Источник:** Event Aggregate
**Описание:** Событие опубликовано
**Полезная нагрузка:**
```json
{
  "eventId": "uuid",
  "eventType": "string",
  "sourceDomain": "enum",
  "aggregateId": "uuid",
  "aggregateType": "string",
  "data": "object",
  "publishedDate": "datetime",
  "version": "integer"
}
```
**Подписчики:**
- Все домены (подписка на события)
- Data Lakehouse (сохранение событий)

### PipelineCompleted
**Источник:** DataProduct Aggregate
**Описание:** Пайплайн обработки данных завершён
**Полезная нагрузка:**
```json
{
  "pipelineId": "uuid",
  "dataProductId": "uuid",
  "executionId": "uuid",
  "status": "enum",
  "processedRecords": "integer",
  "executionTime": "integer",
  "completedDate": "datetime",
  "metrics": "object"
}
```
**Подписчики:**
- Portal Domain (обновление данных)
- Data Catalog (обновление метаданных)

## 7. Портал самообслуживания (Self-Service Analytics Context)

### DashboardCreated
**Источник:** Dashboard Aggregate
**Описание:** Дашборд создан
**Полезная нагрузка:**
```json
{
  "dashboardId": "uuid",
  "dashboardName": "string",
  "ownerId": "uuid",
  "description": "string",
  "widgets": "array",
  "layout": "object",
  "createdDate": "datetime",
  "permissions": "object"
}
```
**Подписчики:**
- Data Platform (регистрация использования данных)

### ReportGenerated
**Источник:** Report Aggregate
**Описание:** Отчёт сгенерирован
**Полезная нагрузка:**
```json
{
  "reportId": "uuid",
  "reportName": "string",
  "ownerId": "uuid",
  "reportType": "enum",
  "parameters": "object",
  "executionTime": "integer",
  "generatedDate": "datetime",
  "fileSize": "integer"
}
```
**Подписчики:**
- Data Platform (аналитика использования)

### QueryExecuted
**Источник:** Query Aggregate
**Описание:** Запрос выполнен
**Полезная нагрузка:**
```json
{
  "queryId": "uuid",
  "userId": "uuid",
  "queryText": "string",
  "executionTime": "integer",
  "resultSize": "integer",
  "executedDate": "datetime",
  "performance": "object"
}
```
**Подписчики:**
- Data Platform (мониторинг производительности)

## События интеграции между доменами

### TreatmentCompleted → PaymentRequired
**Источник:** Medical Domain
**Назначение:** Fintech Domain
**Описание:** Требуется оплата за лечение

### PaymentProcessed → TreatmentConfirmed
**Источник:** Fintech Domain
**Назначение:** Medical Domain
**Описание:** Лечение подтверждено после оплаты

### PrescriptionCreated → InventoryCheck
**Источник:** Medical Domain
**Назначение:** Pharma Domain
**Описание:** Проверка наличия лекарств

### EquipmentRequested → AvailabilityCheck
**Источник:** Medical Domain
**Назначение:** Equipment Domain
**Описание:** Проверка доступности оборудования

### PatientDataUpdated → ModelRetrain
**Источник:** Medical Domain
**Назначение:** AI Domain
**Описание:** Переобучение моделей на новых данных

### AnomalyDetected → MaintenanceRequired
**Источник:** Equipment Domain
**Назначение:** Maintenance Service
**Описание:** Требуется обслуживание оборудования

## Схемы событий

Все события должны соответствовать схеме Apache Avro для обеспечения совместимости версий:

```json
{
  "type": "record",
  "name": "DomainEvent",
  "namespace": "com.future.architecture.events",
  "fields": [
    {"name": "eventId", "type": "string"},
    {"name": "eventType", "type": "string"},
    {"name": "aggregateId", "type": "string"},
    {"name": "aggregateType", "type": "string"},
    {"name": "timestamp", "type": "long"},
    {"name": "version", "type": "int"},
    {"name": "data", "type": "string"},
    {"name": "metadata", "type": "map", "values": "string"}
  ]
}
```
