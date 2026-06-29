-- AlterTable
ALTER TABLE "Transaction" ADD COLUMN     "customerAddress" TEXT,
ADD COLUMN     "customerPhone" TEXT,
ADD COLUMN     "quantity" INTEGER NOT NULL DEFAULT 1;
