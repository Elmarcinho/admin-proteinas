part of 'company_bloc.dart';

class CompanyState extends Equatable {

  final String image;


  const CompanyState({
    this.image = ''
  });

  CompanyState copyWith({
    String? image
  })=> CompanyState(
    image: image ?? this.image
  );
  
  @override
  List<Object> get props => [ image];
}


