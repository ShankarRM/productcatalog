FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /webapp
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["ProductCatalog/ProductCatalog.csproj", "ProductCatalog/"]
RUN dotnet restore "ProductCatalog/ProductCatalog.csproj"
COPY . .
WORKDIR "/src/ProductCatalog"
RUN dotnet build "ProductCatalog.csproj" -c Release -o /webapp

FROM build AS publish
RUN dotnet publish "ProductCatalog.csproj" -c Release -o /webapp

FROM base AS final
WORKDIR /webapp
COPY --from=publish /webapp .
ENTRYPOINT ["dotnet", "ProductCatalog.dll"]
