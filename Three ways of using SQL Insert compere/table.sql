

-- tables: TenantTransaction
-- drop table [TenantTransaction]
CREATE TABLE [TenantTransaction]
(
    [tenantId] INT NOT NULL,
    [serviceId] smallint NOT NULL,
    [id] INT NOT NULL,
    [serialNo] UNIQUEIDENTIFIER NOT NULL,
    [currencyId] CHAR(3) NOT NULL,
    [amount] MONEY NOT NULL,
    [toCurrencyId] CHAR(3),
    [toAmount] MONEY,
    [description] NVARCHAR(MAX) NOT NULL,
    [status] TINYINT NOT NULL DEFAULT(20),
    [creatorUserId] INT NOT NULL,
    [createdAt] DATETIME NOT NULL DEFAULT(GETDATE()),
    [updatorUserId] INT NOT NULL,
    [updatedAt] DATETIME NOT NULL DEFAULT(GETDATE())
);
Go

-- constraints: primary key of TenantTransaction
ALTER TABLE [TenantTransaction] ADD CONSTRAINT PK_TenantTransaction PRIMARY KEY (tenantId, serviceId, id);
Go

-- constraints: unique key of TenantTransaction
ALTER TABLE [TenantTransaction] ADD CONSTRAINT UQ_TenantTransaction UNIQUE (tenantId, serialNo);
Go

-- constraints: foreign key of TenantTransaction's TenantService
ALTER TABLE [TenantTransaction] ADD CONSTRAINT FK_TenantTransaction_TenantService FOREIGN KEY ([tenantId], [serviceId]) REFERENCES [TenantService]([tenantId], [serviceId]);
Go

-- constraints: foreign key of TenantTransaction's TenantCurrency
ALTER TABLE [TenantTransaction] ADD CONSTRAINT FK_TenantTransaction_TenantCurrency FOREIGN KEY ([tenantId], [currencyId]) REFERENCES [TenantCurrency]([tenantId], [id]);
Go

-- constraints: foreign key of TenantTransaction's ToTenantCurrency
ALTER TABLE [TenantTransaction] ADD CONSTRAINT FK_TenantTransaction_ToTenantCurrency FOREIGN KEY ([tenantId], [toCurrencyId]) REFERENCES [TenantCurrency]([tenantId], [id]);
Go

-- constraints: foreign key of TenantTransaction's Creator
ALTER TABLE [TenantTransaction] ADD CONSTRAINT FK_TenantTransaction_Creator FOREIGN KEY ([creatorUserId]) REFERENCES [User]([id]);
Go

-- constraints: foreign key of TenantTransaction's Updator
ALTER TABLE [TenantTransaction] ADD CONSTRAINT FK_TenantTransaction_Updator FOREIGN KEY ([updatorUserId]) REFERENCES [User]([id]);
Go

-- indexes: TenantTransaction
-- drop INDEX IX_TenantTransaction_TenantId_SerialNo ON [TenantTransaction];
CREATE NONCLUSTERED INDEX IX_TenantTransaction_TenantId_SerialNo ON [TenantTransaction] ([tenantId], [serialNo]);
GO

-- indexes: TenantTransaction
-- drop INDEX IX_TenantTransaction_CurrencyId ON [TenantTransaction];
CREATE NONCLUSTERED INDEX IX_TenantTransaction_CurrencyId ON [TenantTransaction] ([tenantId], [currencyId]);
GO

-- indexes: TenantTransaction
-- drop INDEX IX_TenantTransaction_ToCurrencyId ON [TenantTransaction];
CREATE NONCLUSTERED INDEX IX_TenantTransaction_ToCurrencyId ON [TenantTransaction] ([tenantId], [toCurrencyId]);
GO

-- indexes: TenantTransaction
-- drop INDEX IX_TenantTransaction_Status ON [TenantTransaction];
CREATE NONCLUSTERED INDEX IX_TenantTransaction_Status ON [TenantTransaction] ([tenantId], [status]);
GO

-- indexes: TenantTransaction
-- drop INDEX IX_TenantTransaction_CreatedAt ON [TenantTransaction];
CREATE NONCLUSTERED INDEX IX_TenantTransaction_CreatedAt ON [TenantTransaction] ([tenantId], [createdAt]);
GO

-- indexes: TenantTransaction
-- drop INDEX IX_TenantTransaction_UpdatedAt ON [TenantTransaction];
CREATE NONCLUSTERED INDEX IX_TenantTransaction_UpdatedAt ON [TenantTransaction] ([tenantId], [updatedAt]);
GO

-- indexes: TenantTransaction
-- drop INDEX IX_TenantTransaction_MainIndex ON [TenantTransaction];
CREATE NONCLUSTERED INDEX IX_TenantTransaction_MainIndex ON [TenantTransaction]
(
    [tenantId],
    [serviceId],
    [currencyId],
    [toCurrencyId],
    [updatedAt]
);
GO