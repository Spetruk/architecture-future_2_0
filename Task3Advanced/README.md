# Карта рисков трансформации

## 1. Архитектурные риски

| № | Риск | Вероятность | Влияние | Описание | Индикаторы |
|---|------|-------------|---------|----------|------------|
| A1 | Потеря данных при миграции из Legacy DWH | Средняя | Критическое | Повреждение или потеря медицинских карт и финансовых данных при переносе из SQL Server 2008 | Расхождения > 0.01%, ошибки валидации > 100/день, downtime > 4 часа |
| A2 | Деградация производительности аналитики | Высокая | Высокое | Замедление выполнения запросов в Data Lakehouse по сравнению с оптимизированным DWH | p95 latency > 60 сек, жалобы > 5/день, CPU > 80% |
| A3 | Отказ Kafka Event Bus | Средняя | Критическое | Single point of failure для всей событийной архитектуры | Consumer lag > 10000, broker down > 2/3, latency > 1 сек |
| A4 | Несовместимость схем событий | Средняя | Среднее | Breaking changes при эволюции событийных схем между версиями | Ошибки десериализации > 1%, DLQ > 1000/час |
| A5 | Переполнение Data Lakehouse | Средняя | Среднее | Неконтролируемый рост данных без retention policies | Рост > 50 TB/месяц, стоимость > бюджета на 20%, small files > 1M |
| A6 | Нарушение ACID при распределённых транзакциях | Средняя | Высокое | Inconsistency при сбоях в Saga Pattern между доменами | Orphaned records > 10/день, ручная компенсация |

## 2. Технологические риски

| № | Риск | Вероятность | Влияние | Описание | Индикаторы |
|---|------|-------------|---------|----------|------------|
| T1 | Недостаток экспертизы в новом стеке | Высокая | Высокое | Команда не имеет опыта с Iceberg, Kafka, Data Mesh | MTTR > 4 часа, incidents > 5/неделя, velocity < 50% |
| T2 | Vendor Lock-in в Yandex Cloud | Средняя | Среднее | Зависимость от managed-сервисов при санкциях | Нативные API > 30%, нет backup плана |
| T3 | Проблемы масштабирования Iceberg | Средняя | Среднее | Performance bottlenecks при петабайтах данных | Compaction > 24ч, metadata ops > 5 сек |
| T4 | Несовместимость версий в экосистеме | Средняя | Среднее | Конфликты между Spark, Flink, Iceberg, Nessie | Ошибки при обновлении, rollback |
| T5 | Превышение облачных затрат | Высокая | Среднее | Неоптимизированное использование ресурсов | Monthly bill > бюджет на 30%, waste > 20% |
| T6 | Latency в событийной архитектуре | Средняя | Среднее | End-to-end latency превышает near-real-time требования | E2E latency > 30 мин, lag > 10000 |

## 3. Организационные риски

| № | Риск | Вероятность | Влияние | Описание | Индикаторы |
|---|------|-------------|---------|----------|------------|
| O1 | Сопротивление команды изменениям | Высокая | Высокое | Разработчики саботируют переход на новый стек или увольняются | Turnover > 20%, вовлечённость < 60% |
| O2 | Отсутствие Product Owner для Data Products | Средняя | Высокое | Нет чёткого ownership данных в парадигме Data Mesh | DP без владельца > 30%, SLA fail > 50% |
| O3 | Конфликт приоритетов между доменами | Высокая | Среднее | Домены конкурируют за ресурсы, бюджет, приоритеты | Эскалации > 2/месяц, задержки интеграций |
| O4 | Недостаточное финансирование | Средняя | Критическое | Дефицит бюджета останавливает проект на половине | Budget util > 90% в фазе 1, отложенный hiring > 5 |
| O5 | Недостаточная поддержка от бизнеса | Средняя | Высокое | Бизнес не понимает ценность, продолжает использовать legacy | Adoption < 50% через 6 мес, негативный feedback |
| O6 | Потеря ключевых экспертов | Средняя | Высокое | Уход архитекторов/tech leads в процессе трансформации | Bus factor = 1, нет документации |

## 4. Риски безопасности и комплаенса

| № | Риск | Вероятность | Влияние | Описание | Индикаторы |
|---|------|-------------|---------|----------|------------|
| S1 | Утечка персональных медицинских данных | Средняя | Критическое | Breach при переносе в облако и между доменами | Security incidents > 1/квартал, неправильные ACL |
| S2 | Несоответствие требованиям регуляторов | Средняя | Критическое | Нарушение требований ЦБ РФ, Росздравнадзора, 152-ФЗ | Замечания регуляторов, нет сертификатов |
| S3 | Недостаточная изоляция между доменами | Средняя | Высокое | Один скомпрометированный домен получает доступ к другим | Cross-domain access, нет network segmentation |
| S4 | Отсутствие audit trail | Низкая | Высокое | Невозможность расследования инцидентов | Gaps в логах > 1%, хранение < 3 лет |

## 5. Интеграционные риски

| № | Риск | Вероятность | Влияние | Описание | Индикаторы |
|---|------|-------------|---------|----------|------------|
| I1 | Проблемы совместимости с legacy системами | Высокая | Высокое | PowerBuilder и SQL Server 2008 не интегрируются с REST API | Integration failures > 5%, timeouts |
| I2 | Ошибки в антикоррупционном слое | Средняя | Среднее | Bugs в DWH Adapter или Camel Bridge | Data errors > 0.1%, rollback интеграций |
| I3 | Перегрузка интеграционных точек | Средняя | Среднее | API Gateway становится bottleneck | Response time > 1 сек, error rate > 1% |

## Матрица рисков (Вероятность × Влияние)

```
Критическое |  A1  A3  O4  S1  S2                    |
Высокое     |  A2  A6  T1  O1  O2  O5  O6  S3  I1    |
Среднее     |  A4  A5  T2  T3  T4  T5  T6  O3  I2  I3|
Низкое      |  S4                                     |
            |_______________________________________|
            Низкая    Средняя         Высокая
                    ВЕРОЯТНОСТЬ
```

## Топ-10 критических рисков (для приоритизации)

1. **A1** - Потеря данных при миграции (Средняя × Критическое)
2. **A3** - Отказ Kafka Event Bus (Средняя × Критическое)
3. **O4** - Недостаточное финансирование (Средняя × Критическое)
4. **S1** - Утечка медицинских данных (Средняя × Критическое)
5. **S2** - Несоответствие регуляторам (Средняя × Критическое)
6. **T1** - Недостаток экспертизы (Высокая × Высокое)
7. **O1** - Сопротивление команды (Высокая × Высокое)
8. **A2** - Деградация производительности (Высокая × Высокое)
9. **I1** - Проблемы с legacy (Высокая × Высокое)
10. **O2** - Нет владельцев Data Products (Средняя × Высокое)

---

# План управления рисками

## Технические меры

### Мера 1: Стратегия безопасной миграции данных
**Риски:** A1, I1, I2

**Подход:**
- **Фаза 1 (0-2 мес):** Полная инвентаризация DWH, создание Data Catalog, разработка DWH Adapter
- **Фаза 2 (2-4 мес):** Пилотная миграция 5-10 TB некритичных данных с полной reconciliation
- **Фаза 3 (4-12 мес):** Dual-write (DWH + Lakehouse), CDC через Debezium, постепенное переключение consumers (10% → 50% → 90% → 100%)
- **Фаза 4 (12-18 мес):** Decommission DWH, архивирование как read-only backup

**Инструменты:**
- Great Expectations (data quality)
- Debezium (CDC)
- Apache Spark (batch migration)
- Custom reconciliation scripts

**Критерии успеха:**
- Data loss = 0
- Reconciliation errors < 0.001%
- Downtime < 4 часа

---

### Мера 2: High Availability для Kafka
**Риски:** A3, T6

**Архитектура:**
- 3+ brokers в разных AZ
- Replication factor: 3
- Min in-sync replicas: 2
- Producer: acks=all, idempotence=true
- Consumer: enable.auto.commit=false

**DR:**
- Cross-region replication (MirrorMaker 2)
- RTO: 15 минут
- RPO: 5 минут

**Мониторинг:**
- Kafka lag (Burrow)
- Alert на lag > 10000

---

### Мера 3: Schema Evolution Strategy
**Риски:** A4

**Подход:**
- Confluent Schema Registry
- Avro формат
- FULL compatibility mode
- Версионирование (semver)
- Запрещено: удаление полей, изменение типов
- Разрешено: добавление optional полей

**Процесс:**
1. Создать схему v2
2. Тест compatibility
3. Deploy consumers на v2
4. Deploy producers на v2
5. Deprecate v1 через 3 месяца

---

### Мера 4: Lakehouse оптимизация
**Риски:** A2, A5, T3

**Iceberg Best Practices:**
- Partition по date/hour
- File size target: 512 MB - 1 GB
- Daily compaction
- Monthly: expire snapshots (retention 90 days)

**Dremio Tuning:**
- Reflections (materialized views)
- Query result caching (TTL: 1 час)
- Resource pools (high/medium/low priority)

**Storage Tiering:**
- Hot (SSD): 30 days
- Warm (HDD): 30-180 days
- Cold (Glacier): 180+ days

---

### Мера 5: Distributed Transaction Management
**Риски:** A6

**Saga Pattern:**
- Choreography (event-driven)
- Transactional Outbox (Debezium)
- Idempotency через Redis (TTL: 7 дней)
- Saga state в PostgreSQL
- Timeout: 30 сек, retry: 3 attempts

**Пример:**
1. Medical: Create patient → PatientCreated
2. Fintech: Create account → AccountCreated
3. Failure: компенсация DeletePatient

**Инструменты:**
- Temporal (orchestration)
- Debezium (Outbox)
- Redis (idempotency)

---

### Мера 6: Multi-Cloud Strategy
**Риски:** T2

**Архитектура:**
- Primary: Yandex Cloud
- Secondary: VK Cloud (DR)
- Terraform для IaC
- K8s для portability
- S3-compatible API

**DR Plan:**
- Async replication: lag < 5 мин
- RTO: 1 час (region failure)
- RTO: 4 часа (full outage)
- DR drill раз в квартал

---

### Мера 7: Comprehensive Observability
**Риски:** A2, A3, T3, T6, I3

**Three Pillars:**
1. **Metrics** (Prometheus + Grafana)
   - Infrastructure: CPU, memory, disk
   - Application: latency, errors, throughput
   - Business: transactions/min, data freshness

2. **Logging** (ELK)
   - Structured JSON
   - Retention: 30d hot, 1y warm, 7y cold
   - Correlation IDs

3. **Tracing** (Jaeger/Tempo)
   - End-to-end request tracing
   - Performance bottlenecks

**SLOs:**
- Medical: 99.9% availability, p95 < 500ms
- Fintech: 99.99% availability, p95 < 100ms
- Data Platform: freshness < 15 min, p95 < 30s

**Alerting:**
- P0 (Critical): immediate PagerDuty
- P1 (High): 15 min response
- P2 (Medium): 4 hours
- P3 (Low): next day

---

### Мера 8: Security & Compliance Framework
**Риски:** S1, S2, S3, S4

**Defense in Depth:**

1. **Network:**
   - VPC isolation per environment
   - Security Groups (least privilege)
   - K8s Network Policies

2. **IAM:**
   - Keycloak SSO + MFA
   - OPA для authorization (RBAC/ABAC)
   - Vault для secrets (rotation 30 дней)

3. **Data Protection:**
   - Encryption at rest (TDE, SSE)
   - Encryption in transit (TLS 1.3, mTLS)
   - Data classification (4 levels)
   - PII masking в non-prod
   - Data residency (Russia only для medical/fintech)

4. **Audit:**
   - Immutable logs (WORM storage)
   - Retention: 7 лет
   - Log: who, what, when, where, result

**Compliance:**
- GDPR, 152-ФЗ (medical)
- PCI DSS, ЦБ РФ (fintech)
- ISO 27001, SOC 2, ISO 13485

**Incident Response:**
- Detection → Triage (15 мин) → Investigation (1-4ч) → Containment (2-8ч) → Recovery (8-24ч) → Post-mortem (3 дня)


---

## Сводная таблица: Риски → Меры

| Риск | Тип меры | Мера | Эффективность |
|------|----------|------|---------------|
| A1 | Техническая | Мера 1: Безопасная миграция | Высокая |
| A2 | Техническая | Мера 4: Lakehouse оптимизация | Высокая |
| A3 | Техническая | Мера 2: HA для Kafka | Высокая |
| A4 | Техническая | Мера 3: Schema Evolution | Высокая |
| A5 | Техническая | Мера 4: Lakehouse оптимизация | Средняя |
| A6 | Техническая | Мера 5: Transaction Management | Средняя |
| T1 | Организационная | Мера 9: Change Management | Высокая |
| T1 | Организационная | Мера 12: Knowledge Management | Средняя |
| T2 | Техническая | Мера 6: Multi-Cloud | Средняя |
| T3 | Техническая | Мера 4: Lakehouse оптимизация | Средняя |
| T4 | Техническая | Мера 7: Observability | Низкая |
| T5 | Техническая | Мера 7: Observability | Средняя |
| T5 | Организационная | Мера 11: Budget Planning | Высокая |
| T6 | Техническая | Мера 2: HA для Kafka | Средняя |
| O1 | Организационная | Мера 9: Change Management | Высокая |
| O2 | Организационная | Мера 10: Data Mesh Governance | Высокая |
| O3 | Организационная | Мера 10: Data Mesh Governance | Высокая |
| O4 | Организационная | Мера 11: Budget Planning | Высокая |
| O5 | Организационная | Мера 9: Change Management | Средняя |
| O5 | Организационная | Мера 13: Business Adoption | Высокая |
| O6 | Организационная | Мера 12: Knowledge Management | Средняя |
| S1 | Техническая | Мера 8: Security Framework | Высокая |
| S2 | Техническая | Мера 8: Security Framework | Высокая |
| S3 | Техническая | Мера 8: Security Framework | Высокая |
| S4 | Техническая | Мера 8: Security Framework | Высокая |
| I1 | Техническая | Мера 1: Безопасная миграция | Средняя |
| I2 | Техническая | Мера 1: Безопасная миграция | Средняя |
| I3 | Техническая | Мера 7: Observability | Средняя |

---

## KPI для мониторинга эффективности мер

### Технические KPI
- Data loss incidents: 0
- System availability: > 99.9%
- P95 query latency: < 30 сек
- Data freshness: < 15 минут
- Security incidents: 0
- Cost variance: < 10%

### Организационные KPI
- Employee turnover: < 10%
- Training completion: > 95%
- Adoption rate: > 80% (year 1)
- Employee satisfaction: > 4/5
- Bus factor: ≥ 2 для всех критичных областей

### Бизнес KPI
- Time-to-insight: сокращение на 60%
- Report generation: сокращение на 40%
- Cost per query: снижение на 30%
- New data products: > 10 в год
- Regulatory compliance: 100%