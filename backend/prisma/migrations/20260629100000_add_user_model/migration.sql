-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "phone" TEXT,
    "address" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AlterTable: Add userId column (nullable first for existing data)
ALTER TABLE "Transaction" ADD COLUMN "userId" INTEGER;

-- Create a default user for existing transactions (if any)
INSERT INTO "User" ("name", "email", "password", "phone", "updatedAt")
VALUES ('System Admin', 'admin@camptrack.id', '$2b$12$defaultHashedPasswordPlaceholder000000000000000000', NULL, NOW())
ON CONFLICT DO NOTHING;

-- Update existing transactions to reference the default user
UPDATE "Transaction" SET "userId" = (SELECT "id" FROM "User" WHERE "email" = 'admin@camptrack.id' LIMIT 1)
WHERE "userId" IS NULL;

-- Now make userId NOT NULL
ALTER TABLE "Transaction" ALTER COLUMN "userId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
