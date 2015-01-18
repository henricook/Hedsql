{-|
Module      : Hedsql/Drivers/PostgreSQL/Constructor.hs
Description : PostgreSQL specific constructors.
Copyright   : (c) Leonard Monnier, 2014
License     : GPL-3
Maintainer  : leonard.monnier@gmail.com
Stability   : experimental
Portability : portable

PostgreSQL specific constructors for functions/clauses specific to this vendor.
-}
module Hedsql.Drivers.PostgreSQL.Constructor
    ( lateral
    , default_
    ) where

import Hedsql.Common.Constructor
import Hedsql.Common.DataStructure
import Hedsql.Drivers.PostgreSQL.Driver

-- Public.

-- | Create a sub-query preceded by LATERAL.
lateral :: Select PostgreSQL -> String -> TableRef PostgreSQL
lateral select alias = LateralTableRef select $ TableRefAs alias []

{-|
DEFAULT instruction when used to insert a DEFAULT value.
For example:
> INSERT INTO films Values (DEFAULT, 'Bananas', 88, '1971-07-13', 'Comedy');
-}
default_ :: SqlValue PostgreSQL
default_ = SqlValueDefault