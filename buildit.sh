#/bin/bash
git clone --recurse-submodules https://github.com/JSPrismarine/JSPrismarine.git
mv JSPrismarine/* /app/data
wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -
pnpm run install
pnpm run build
echo -e "install done !"
