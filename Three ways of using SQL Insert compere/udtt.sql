-- types: TenantTransactionData
-- drop type TenantTransactionData
CREATE TYPE TenantTransactionData AS TABLE
(
    [tenantId] INT,
    [serviceId] smallint,
    [id] INT,
    [serialNo] UNIQUEIDENTIFIER,
    [currencyId] CHAR(3),
    [amount] MONEY,
    [toCurrencyId] CHAR(3),
    [toAmount] MONEY,
    [description] NVARCHAR(MAX),
    [status] TINYINT,
    [creatorUserId] INT,
    [createdAt] DATETIME,
    [updatorUserId] INT,
    [updatedAt] DATETIME
);
Go
