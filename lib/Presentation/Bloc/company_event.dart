part of 'company_bloc.dart';

sealed class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}


class GetCompanyEvent extends CompanyEvent{ 
  const GetCompanyEvent();
}

class CreateUpdateCompanyEvent extends CompanyEvent{ 
  final String qr;
  final bool isCreate;
  const CreateUpdateCompanyEvent(this.qr, this.isCreate);
}

class ImageEvent extends CompanyEvent{
   final String path;
  const ImageEvent(this.path);
}


