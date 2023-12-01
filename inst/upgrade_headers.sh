CMDSTAN_VER="2.33.1"


wget https://github.com/stan-dev/cmdstan/releases/download/v$CMDSTAN_VER/cmdstan-$CMDSTAN_VER.tar.gz
tar -xf cmdstan-$CMDSTAN_VER.tar.gz
rm -rf include
mkdir -p include

cp -r cmdstan-$CMDSTAN_VER/src/cmdstan include/cmdstan
cp -r cmdstan-$CMDSTAN_VER/stan/src/stan include/stan
cp -r cmdstan-$CMDSTAN_VER/stan/lib/stan_math/stan/math include/stan/math
cp -r cmdstan-$CMDSTAN_VER/stan/lib/stan_math/stan/math.hpp include/stan/math.hpp
cp -r cmdstan-$CMDSTAN_VER/stan/lib/rapidjson_*/rapidjson include/rapidjson

mkdir include/sundials
cp -r cmdstan-$CMDSTAN_VER/stan/lib/stan_math/lib/sundials_*/include include/sundials

chmod +x cmdstan-$CMDSTAN_VER/bin/mac-stanc
cmdstan-$CMDSTAN_VER/bin/mac-stanc estimator/estimator.stan --O1 --allow-undefined

rm cmdstan-$CMDSTAN_VER.tar.gz
rm -rf cmdstan-$CMDSTAN_VER