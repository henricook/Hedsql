{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

{-|
Module      : Hedsql/Common/Constructor/DataManipulation.hs
Description : DELETE, INSERT and UPDATE SQL statements.
Copyright   : (c) Leonard Monnier, 2014
License     : GPL-3
Maintainer  : leonard.monnier@gmail.com
Stability   : experimental
Portability : portable

SQL data manipulation queries constructors for DELETE, INSERT and UPDATE.
-}
module Hedsql.Common.Constructor.DataManipulation
    (
      assign
    , deleteFrom
    , insertInto
    , insertIntoCols
    , update
    ) where

import Hedsql.Common.Constructor.Columns
import Hedsql.Common.Constructor.Tables
import Hedsql.Common.Constructor.Values
import Hedsql.Common.DataStructure

-- private functions.

-- public functions.

-- | Create a column/value pair to be used in an UPDATE statement.
assign ::
    (
       CoerceToCol      a [Column c]
    ,  CoerceToSqlValue b [SqlValue c]
    )
    => a -- ^ Column or name of the column.
    -> b -- ^ Value for this column.
    -> Assignment c
assign a val = Assignment (column a) (ValueExpr $ value val)

-- | Create a DELETE FROM statement.
deleteFrom ::
       CoerceToTable a (Table b)
    => a -- ^ Table or name of the table to delete from.
    -> Delete b
deleteFrom t = Delete (table t) Nothing

{-|
Create an INSERT INTO statement.

The values to insert are a list of list of values because you may insert more
than one row in the database.
-}
insertInto ::
    (
       CoerceToTable     a  (Table c)
    ,  CoerceToSqlValue [b] [SqlValue c]
    )
    =>   a    -- ^ Table or name of the table to insert the data into.
    -> [[b]]  -- ^ Values to insert.
    -> Insert c
insertInto t vals = Insert (table t) Nothing $ map values vals

{-|
Create an INSERT INTO statement where the columns are specified.

The values to insert are a list of list of values because you may insert more
than one row in the database.
-}
insertIntoCols ::
    (
      CoerceToTable     a  (Table d)
    , CoerceToCol       b  [Column d]
    , CoerceToSqlValue [c] [SqlValue d]
    )
    =>   a     -- ^ Table or name of the table to insert the data into.
    ->  [b]    -- ^ Columns or names of the columns.
    -> [[c]]   -- ^ Values to insert.
    -> Insert d
insertIntoCols t cols vals =
    Insert (table t) (Just $ map column cols) $ map values vals

-- | Create an UPDATE statement.
update ::
       CoerceToTable a (Table b)
    => a              -- ^ Table to update.
    -> [Assignment b] -- ^ Column/value assignements.
    -> Update b
update t assignments = Update (table t) assignments Nothing